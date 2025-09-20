#  Copyright (c) 2023. seamus@corvideon.ie
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

package Actor;
use strict;
use warnings;
use threads;
use Thread::Queue;
use Scalar::Util qw(weaken);

########################################################################################################################
# Helpers

package HandlerRegistry {
  sub new {
    my ($class, %args) = @_;
    my $self = {
      map   => {},
      name  => $args{name} || '',
      check => $args{check} // 1,
    };
    bless $self, $class;
    return $self;
  }

  sub get {
    my ($self, $typ) = @_;
    my $ret = $self->{map}->{$typ} || [];
    return @$ret;
  }

  sub put {
    my ($self, $typ, $handler) = @_;
    die "TypeError: typ must be a class" unless ref($typ) eq 'CODE';
    die "TypeError: handler must be callable" unless ref($handler) eq 'CODE';
    my $s = $self->{map}->{$typ} || [];
    push @$s, $handler;
    $self->{map}->{$typ} = $s;
  }

  sub show {
    my ($self) = @_;
    foreach my $typ (keys %{ $self->{map} }) {
      my $handlers = $self->{map}->{$typ};
      print "  $typ : @$handlers\n";
    }
  }

  sub register {
    my ($self, $typ) = @_;
    if ($self->{check}) {
      if ($typ eq 'OtherMessage') {
        die "Exception: Actors cannot watch msg $typ";
      }
    }
    return sub {
      my ($func) = @_;
      $self->put($typ, $func);
      return $func;
    };
  }
}

# return "file:line" for the caller
sub caller_info {
  my ($extra_levels) = @_;
  $extra_levels //= 0;
  my ($package, $filename, $line) = caller(1 + $extra_levels);
  return "$filename:$line";
}

sub get_caller {
  my ($extra_levels) = @_;
  $extra_levels //= 0;
  my $level = 2 + $extra_levels;
  my $caller = (caller($level))[0]->{self};
  return $caller;
}

########################################################################################################################
# Messages

# Used internally to tell when an actor fails to handle a message
package OtherMessage {}

# stops the actor once this message is handled in the queue
package Stop {}

# The actor will automatically receive these messages when it's started or stopped
package Started {}
package Stopped {}

# When actor1 submits Watch() to actor2, actor1 will receive this message when actor1 is stopped.
# actor2 can get a reference to actor1 by calling self.sender.
package ActorStarted {}
package ActorStopped {}

package BeforeHandling {
  sub new {
    my ($class, $message) = @_;
    my $self = {
      message => $message,
    };
    bless $self, $class;
    return $self;
  }
}

package AfterHandling {
  sub new {
    my ($class, $message, $exception) = @_;
    my $self = {
      message   => $message,
      exception => $exception,
    };
    bless $self, $class;
    return $self;
  }
}

# If an actor is watching another actor it will get this exception
package ActorException {
  sub new {
    my ($class, $exception) = @_;
    my $self = {
      exception => $exception,
    };
    bless $self, $class;
    return $self;
  }
}

# This is thrown when tell() or ask() is called on a stopped actor.
package ActorStoppedException {
  use base 'Exception::Class';
  __PACKAGE__->attributes(qw(actor message));
  sub new {
    my ($class, %args) = @_;
    my $self = $class->SUPER::new();
    $self->{actor} = $args{actor};
    $self->{message} = $args{message};
    return $self;
  }
}

########################################################################################################################
# Actor

{
  package IActor;

  sub start {}
  sub stop {}
  sub join {}
  sub add_watcher {}
  sub tell {}
  sub ask {}
}

{
  package Actor;

  our @ISA = qw(IActor);

  sub new {
    my ($class, %args) = @_;
    my $self = {
      name     => $args{name} // '',
      executor => $args{executor},
      lock     => threads::shared::shared_clone(threads::shared::new_lock()),
      current_future => undef,
      watchers => threads::shared::shared_clone({}),
    };
    bless $self, $class;

    if (!$self->{executor}) {
      $self->{executor} = Executor->new(start => 0);
    }

    return $self;
  }

  sub _inspect_sender {
    my ($self, $extra_levels) = @_;
    my $callr = get_caller($extra_levels);
    if (defined($callr) && ref($callr) eq 'Actor') {
      return $callr;
    }
    return undef;
  }

  sub start {
    my ($self, %args) = @_;
    {
      lock $self->{lock};

      $self->{executor}->start();

      my $sender = $self->_inspect_sender(1);

      $self->tell(Started->new(), sender => $sender, trace => caller_info());

      # tell watchers
      my $started = ActorStarted->new();
      foreach my $actor (values %{ $self->{watchers} }) {
        $actor->tell($started, sender => $sender);
      }

      return $self;
    }
  }

  sub stop {
    my ($self) = @_;
    {
      lock $self->{lock};

      my $sender = $self->_inspect_sender(1);

      $self->{executor}->stop();

      # tell me i'm Stopped
      $self->_handle_message_with_registry(Stopped->new(), undef, caller_info(), undef);

      # tell watchers
      my $stopped = ActorStopped->new();
      foreach my $actor (values %{ $self->{watchers} }) {
        $actor->tell($stopped, sender => $sender);
      }
    }
  }

  sub is_started {
    my ($self) = @_;
    {
      lock $self->{lock};
      return $self->{executor}->is_started();
    }
  }

  sub join {
    my ($self) = @_;
    return $self->{executor}->join();
  }

  sub add_watcher {
    my ($self, $actor, %args) = @_;
    {
      lock $self->{lock};
      $self->{watchers}{$actor} = $actor;

      if ($args{notify_now}) {
        my $m = undef;
        if ($self->{executor}->is_started()) {
          $m = ActorStarted->new();
        } else {
          $m = ActorStopped->new();
        }
        foreach my $actor (values %{ $self->{watchers} }) {
          $actor->tell($m, sender => $self);
        }
      }
    }
  }

  sub tell {
    my ($self, $message, %args) = @_;
    my $sender = $args{sender} // $self->_inspect_sender(2);
    return $self->_post($message, $sender, $args{delay}, $args{trace});
  }

  sub ask {
    my ($self, $message, %args) = @_;
    my $sender = $args{sender} // $self->_inspect_sender(2);
    my $future = Future->new();
    return $self->_post($message, $sender, $args{delay}, $args{trace}, $future);
  }

  sub _post {
    my ($self, $message, $sender, $delay, $trace, $future) = @_;
    {
      lock $self->{lock};

      # get the caller file:line to show useful trace if an exception is thrown
      $trace //= caller_info(1);

      # run now?
      if (!$delay || $delay == 0) {
        if ($self->{executor}->is_started()) {
          $self->{executor}->submit(Actor::Run->new(
            message => $message,
            sender  => $sender,
            trace   => $trace,
            future  => $future,
            actor   => $self,
          ));
        } else {
          print "raising ActorStoppedException\n";
          Carp::cluck();
          die ActorStoppedException->new(
            actor   => $self,
            message => $message,
          );
        }
      } else {
        # run later
        my $run = sub {
          my ($message, $sender, $trace, $future) = @_;
          if ($self->{executor}->is_started()) {
            $self->{executor}->submit(Actor::Run->new(
              message => $message,
              sender  => $sender,
              trace   => $trace,
              future  => $future,
              actor   => $self,
            ));
          } else {
            if ($future) {
              $future->throw("This actor is stopped");
            }
          }
        };
        my $t = threads->new(
          sub {
            my ($delay, $run, $message, $sender, $trace, $future) = @_;
            sleep $delay;
            $run->($message, $sender, $trace, $future);
          },
          $delay,
          $run,
          $message,
          $sender,
          $trace,
          $future,
        );
        $t->detach();
      }

      return $future;
    }
  }

  #-------------------------------------------------------------------------------------------------------------------
  # THESE CAN BE CALLED BY HANDLER METHODS

  sub reply {
    my ($self, $value) = @_;
    {
      lock $self->{lock};
      if ($self->{current_future}) {
        $self->{current_future}->put($value);
      }
    }
  }

  sub sender {
    my ($self) = @_;
    return $self->{sender};
  }

  #-------------------------------------------------------------------------------------------------------------------

  {
    package Actor::Run;

    sub new {
      my ($class, %args) = @_;
      my $self = {
        message => $args{message},
        sender  => $args{sender},
        trace   => $args{trace},
        future  => $args{future},
        actor   => $args{actor},
      };
      bless $self, $class;
      return $self;
    }

    sub run {
      my ($self) = @_;
      $self->{actor}->_handle_message_with_registry($self->{message}, $self->{sender}, $self->{trace}, $self->{future});
    }
  }

  # the prototype registry with handlers shared by all actors
  our $on = HandlerRegistry->new(name => 'Actor', check => 0);

  # actors call this to obtain the handler decorator. see examples.
  sub make_handles {
    my ($class, %args) = @_;
    my $hr = HandlerRegistry->new(name => $args{name});
    while (my ($typ, $handlers) = each %{ $class->{on}{map} }) {
      foreach my $h (@$handlers) {
        $hr->put($typ, $h);
      }
    }
    return $hr;
  }

  # handles the message
  sub _handle_message_with_registry {
    my ($self, $message, $sender, $trace, $future) = @_;

    my $registry = $self->on;

    my $handlers = $registry->get(ref($message) || 'OtherMessage');
    if (!@$handlers) {
      $handlers = $registry->get('OtherMessage');
    }

    $self->{trace} = $trace;
    $self->{current_future} = $future;
    $self->{sender} = $sender;

    foreach my $handler (@$handlers) {
      foreach my $w (values %{ $self->{watchers} }) {
        eval {
          $w->tell(BeforeHandling->new($message), sender => $self);
        };
        if ($@) {
          print $@;
        }
      }

      my $exception = undef;

      eval {
        $handler->($self, $message);
      };
      if ($@) {
        $exception = $@;

        print "Caller: $trace\n";

        # tell watchers
        foreach my $actor (values %{ $self->{watchers} }) {
          $actor->tell(ActorException->new($exception));
        }
      }

      foreach my $w (values %{ $self->{watchers} }) {
        eval {
          $w->tell(AfterHandling->new($message, $exception), sender => $self);
        };
        if ($@) {
          print $@;
        }
      }
    }

    $self->{current_future} = undef;
    $self->{sender} = undef;
    $self->{trace} = undef;
  }

  sub do_Stop {
    my ($self, $msg) = @_;
    $self->stop();
  }

  sub do_OtherMessage {
    my ($self, $msg) = @_;
    print "Message not handled: $msg from $self->{sender}\n";
  }
}

########################################################################################################################

sub default_exception_handler {
  my ($e) = @_;
  print "$e\n";
  print "$_\n" foreach (Carp::longmess());
}

{
  package Executor;

  sub new {
    my ($class, %args) = @_;
    my $self = {
      exception_handler => $args{exception_handler} // \&default_exception_handler,
      daemon            => $args{daemon} // 1,
      lock              => threads::shared::shared_clone(threads::shared::new_lock()),
      started           => 0,
      on_deck           => Thread::Queue->new(),
      thread            => undef,
    };
    bless $self, $class;

    if ($args{start}) {
      $self->start();
    }

    return $self;
  }

  sub set_exception_handler {
    my ($self, $eh) = @_;
    die "TypeError: exception_handler must be callable" unless ref($eh) eq 'CODE';
    $self->{exception_handler} = $eh;
  }

  sub is_on {
    my ($self) = @_;
    return threads->self() == $self->{thread};
  }

  sub start {
    my ($self) = @_;
    {
      lock $self->{lock};
      if (!$self->{started}) {
        $self->{started} = 1;
        $self->{thread} = threads->create(sub { $self->_run($self->{on_deck}) });
        $self->{thread}->detach() if $self->{daemon};
      }
    }
  }

  sub stop {
    my ($self) = @_;
    {
      lock $self->{lock};
      if ($self->{started}) {
        $self->{started} = 0;
        $self->{on_deck}->enqueue("STOP"); # unblocks the queue
        $self->{on_deck}->purge();
        $self->{thread} = undef;
      }
    }
  }

  sub is_started {
    my ($self) = @_;
    {
      lock $self->{lock};
      return $self->{started};
    }
  }

  sub submit {
    my ($self, $callable) = @_;
    {
      lock $self->{lock};
      die "TypeError: callable must be a CODE reference" unless ref($callable) eq 'CODE';
      $self->{on_deck}->enqueue($callable);
    }
  }

  sub join {
    my ($self) = @_;
    my $t = undef;
    {
      lock $self->{lock};
      return unless defined $self->{thread};
      $t = $self->{thread};
    }
    return $t->join();
  }

  sub _run {
    my ($self, $q) = @_;
    while (1) {

      # stopped?
      if (!$self->{started}) {
        last;
      }

      # wait for a job
      my $callable = $q->dequeue();

      # stop?
      if ($callable eq "STOP") {
        last;
      }

      # call
      eval { $callable->() };
      if ($@) {
        $self->{exception_handler}->($@);
      }
    }
  }
}

########################################################################################################################

{
  package Future;

  sub new {
    my ($class) = @_;
    my $self = {
      event     => threads::shared::shared_clone(Thread::Semaphore->new(0)),
      value     => undef,
      exception => undef,
    };
    bless $self, $class;
    return $self;
  }

  sub put {
    my ($self, $value) = @_;
    $self->{value} = $value;
    $self->{event}->up();
  }

  sub get {
    my ($self, $timeout) = @_;
    if (!$timeout) {
      $self->{event}->down();
    } else {
      if (!$self->{event}->down_nb()) {
        die "Exception: future get() timed out";
      }
    }
    if ($self->{exception}) {
      die $self->{exception};
    }
    return $self->{value};
  }

  sub throw {
    my ($self, $exception) = @_;
    $self->{exception} = $exception;
    $self->{event}->up();
  }
}

1; # End of the code

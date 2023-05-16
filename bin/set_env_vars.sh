#!/bin/bash

echo 'Loading ENV VARS from .env...'

# cd to script dir
cd "${0%/*}" || exit

# cd to project root
cd ..
pwd

# load the .env file

source .env

echo 'Done.'
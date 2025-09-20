# Meek

**Meek** is a **prototype** Modern Perl project that explores advanced LLM (Large Language Model) integrations, custom REACT agent loops, dynamic tool use, and other cutting-edge AI techniques.  
This repository is experimental and intended for research and educational purposes.

---

# Table of Contents
- [Features](#features)
- [Directory Structure](#directory-structure)
- [Prototype Status](#prototype-status)
- [Disclaimer](#disclaimer)
- [References](#references)
- [License](#license)

---

## Features

- **Modern Perl**  
  Written using Modern Perl idioms for robust, maintainable, and expressive code. Leverages CPAN modules and best practices.  

- **Custom REACT Agent Loop**  
  Implements a bespoke REACT (Reasoning and Acting) agent loop to orchestrate tool use and iterative reasoning, inspired by recent LLM research.  
  Inspired by the [React LLM Paper](https://arxiv.org/abs/2210.03629).  
  The agent manages thought/action/observation cycles, enabling dynamic, context-aware problem solving.  

- **Tool Use via Custom Toolformer Implementation**  
  Extensible tool integration allows the LLM agent to call external functions, scripts, or APIs as part of its workflow.  
  Inspired by the [Toolformer: Language Models Can Teach Themselves to Use Tools](https://arxiv.org/abs/2302.04761) paper.  

---

## Directory Structure

- `bin/` – Executable scripts and entry points.  
- `lib/Meek/` – Core Perl modules, including the agent loop, tool interfaces, and utilities.  
- `tools/` – Example external tools callable by the agent.  
- `examples/` – Usage examples and test scripts.  

---

## Prototype Status

This project is an early-stage **prototype**. No warranty provided. Use at your own risk.

---

## Disclaimer

This software comes with **no warranty**. Use at your own risk.  

---

## References

- [React LL]()

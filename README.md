# Meek

- **Meek** is a **prototype** Modern Perl project that explores advanced LLM (Large Language Model) integrations, custom REACT agent loops, dynamic tool use, and other cutting-edge AI techniques.  
- It demonstrates a **Perl implementation of ideas that are typically only implemented in Python**, showing how agent-based LLM techniques can be adapted to Modern Perl.  
- This repository is experimental and intended for research and educational purposes.

---

# Table of Contents
- [Features](#features)
- [Integrated Tools](#integrated-tools)
- [What Meek Can Do](#what-meek-can-do)
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

## Integrated Tools

Meek provides dynamic tool use via a custom REACT agent loop, allowing the LLM agent to call external functions for enhanced reasoning and research. The following tools are included:

- **Calculator**: Evaluates mathematical expressions and returns results.  
- **Current Date/Time**: Retrieves the current date and time with time zone.  
- **Web Page Extractor**: Downloads and extracts the title and main body text from any web page URL.  
- **Bing Search**: Performs web searches using Bing and extracts relevant snippets to answer questions.  
- **Summariser**: Summarizes any text, focusing on concise, information-rich language.

---

## What Meek Can Do

- **Search the Web & Basic Research**: Meek can search the web for up-to-date information, extract text from web pages, and answer factual questions.  
- **Text Summarization & Synthesis**: It can summarize large bodies of text and synthesize information from multiple sources.  
- **Essay & Report Generation**: For complex queries, Meek can conduct research, summarize findings, and generate well-structured essays or reports.  
- **Mathematical & Factual Questions**: Instantly solves math problems and retrieves current date/time as needed.  

These integrated tools allow Meek to answer a wide range of queries—factual, conceptual, or research-based—by combining search, extraction, summarization, and reasoning in a single workflow.  

---

## Prototype Status

This project is an early-stage **prototype**. Contributions, issues, and suggestions are welcome!  

---

## Disclaimer

This software comes with **no warranty**. Use at your own risk.  

---

## References

- [React LLM Paper](https://arxiv.org/abs/2210.03629)  
- [Toolformer Paper (arXiv)](https://arxiv.org/abs/2302.04761)  

---

## License

MIT License

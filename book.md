---
SPDX-License-Identifier: CC-BY-4.0
copyright:
  - SPDX-FileCopyrightText: © 2021 Arm Limited <kristof.beyls@arm.com>
title: 'Low Level Software Security for Compiler Developers'
documentclass: report
papersize: A4
header-includes:
- |
  ```{=latex}
  \usepackage{makeidx}
  \makeindex
  ```
...

# Introduction

Compilers, assemblers and similar tools generate all the binary code that
processors execute.  It is no surprise then that for security analysis and
hardening relevant for binary code, these tools have a major role to play.
Often the only practical way to protect all binaries with a particular security
hardening method is to let the compiler adapt its automatic code generation.

With software security becoming even more important in recent years, it is no
surprise to see an ever increasing variety of security hardening features and
mitigations against vulnerabilities implemented in compilers.

Indeed, compared to a few decades ago, today's compiler developer is much more
likely to work on security features, at least some of their time.

Furthermore, with the ever-expanding range of techniques implemented, it has
become very hard to gain a basic understanding of all security
features implemented in typical compilers.

This poses a practical problem: compiler developers must be able to work on
security hardening features, yet it is hard to gain a good basic understanding
of such compiler features.

This book aims to help developers of code generation tools such as JITs,
compilers, linkers, assemblers, etc. overcome this.

There is a lot of material that can be found explaining individual
vulnerabilities or attack vectors. There are also lots of presentations
explaining specific exploits. But there seems to be a limited set of material
that gives a structured overview of all vulnerabilities and exploits for which
a code generator could play a role in protecting against them.

This book aims to provide such a structured, broad overview.  It does not
necessarily go into full details.  Instead it aims to give a thorough
description of all relevant high-level aspects of attacks, vulnerabilities,
mitigations and hardening techniques. For further details, this book provides
pointers to material with more details on specific techniques.

The purpose of this book is to serve as a guide to every compiler developer
that needs to learn about software security relevant to compilers.  Even though
the focus is on compiler developers, we expect that this book will also be
useful to other people working on low-level software.


## How this book is created

The idea for this book emerged out of a frustration of not finding a good
overview on this topic. Kristof Beyls and Georgia Kouveli, both compiler
engineers working on security features, wished a book like this would exist.
After not finding such a book, they decided to try and write one themselves.
They immediately realized that they do not have all necessary expertise
themselves to complete such a daunting task. So they decided to try and create
this book in an open source style, seeking contributions from many experts.

As you read this, the book remains unfinished. This book may well never be
finished, as new vulnerabilities continue to be discovered regularly. Our hope
is that developing the book as an open source project will allow for it to
continue to evolve and improve. The open source development process of this book
increases the likelihood that it remains relevant as new vulnerabilities and
mitigations emerge.

Kristof and Georgia, the initial authors, are far from experts on all possible
vulnerabilities. So what is the plan to get high quality content to cover all
relevant topics?  It is two-fold.

First, by studying specific topics, they hope to gain enough knowledge to write
up a good summary for this book.

Second, they very much invite and welcome contributions. If you're interested
in potentially contributing content, please go to the home location for the
open source project at https://github.com/llsoftsec/llsoftsecbook.

As a reader, you can also contribute to making this book better.  We highly
encourage feedback, both positive and constructive criticisms.  We prefer
feedback to be received through https://github.com/llsoftsec/llsoftsecbook.


# Memory vulnerability based attacks and mitigations

# Physical access side channel attacks

# Remote access side channel attacks

# Other security topics relevant for compiler developers

# Appendix: contribution guidelines

\printindex

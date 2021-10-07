---
SPDX-License-Identifier: CC-BY-4.0
copyright:
  - SPDX-FileCopyrightText: © 2021 Arm Limited <kristof.beyls@arm.com>
title: 'Low Level Software Security for Compiler Developers'
documentclass: report
papersize: A4
colorlinks: true
link-citations: true
bibliography:
- book.bib
header-includes:
- |
  ```{=latex}
  \usepackage{makeidx}
  \makeindex
  \newcounter{TodoCounter}
  \usepackage[backgroundcolor=white,linecolor=black]{todonotes}
  \let\oldtodo\todo
  \usepackage{bclogo}%  \bcpanchant
  \renewcommand{\todo}[1]{
    \stepcounter{TodoCounter}
    \oldtodo[caption={\arabic{TodoCounter}. #1}]{\bcpanchant #1}
  }
  \newcommand{\missingcontent}[1]{
    \stepcounter{TodoCounter}
    \oldtodo[inline,caption={\arabic{TodoCounter}. #1}]{\bcpanchant \textit{#1}}
  }
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
compilers, linkers and assemblers to overcome this.

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
open source project at <https://github.com/llsoftsec/llsoftsecbook>.

As a reader, you can also contribute to making this book better.  We highly
encourage feedback, both positive and constructive criticisms.  We prefer
feedback to be received through <https://github.com/llsoftsec/llsoftsecbook>.

\missingcontent{Add section describing the structure of the rest of the book.}
 
# Memory vulnerability based attacks and mitigations

## Introduction

An important class of vulnerabilities arise due to memory access errors, such as
buffer overflows, use-after-free accesses and null pointer dereferences. An
attacker can exploit such vulnerabilities to leak sensitive data or
overwrite critical memory locations and gain control of the vulnerable program.
These types of vulnerabilities most commonly occur due to programming errors when
using languages such as C/C++, which do not provide mechanisms to protect the
integrity of memory accesses by default.

Memory vulnerabilities have a long history. The Morris worm in 1988 was the
first widely publicized attack exploiting a buffer overflow. Later, in the
mid-90s a few famous write-ups describing buffer overflows appeared
[@AlephOne1996].  Stack overflows were mitigated with stack canaries and
non-executable stacks, but attackers answered with more ingenious ways to
bypass these mitigations: code reuse attacks, starting from simple attacks like
return-into-libc [@Solar1997] and leading up to Return-Oriented Programming
[@Shacham2007] and even more complex techniques.

To defend against code reuse attacks, the defensive security side came up with
address space layout randomization (ASLR) and control-flow integrity (CFI)
measures. The race continues to this day. Each newly deployed mitigation
results in attempts, often successful, to bypass it, or in alternative, more
complex exploitation techniques, and even tools to automate them.

Memory safe [@Hicks2014] languages are designed with prevention of such
vulnerabilities in mind and use techniques such as bounds checking and
automatic memory management. If these languages promise to eliminate
memory vulnerabilities, why are we still discussing this topic?

On one hand, C and C++ remain very popular languages, particular in the
implementation of low-level software. On the other hand, programs written in
memory safe languages can themselves be vulnerable to memory errors as a result
of bugs in their implementation. Can we fix the problem by switching to memory
safe languages for compiler and runtime implementation? Even if that were as
simple as it sounds, unfortunately there are types of programming errors that
these languages cannot protect against.

Given the rich history of memory vulnerabilities and mitigations and the active
developments in this area, compiler developers are likely to encounter some of
these issues over the course of their careers. This chapter aims to serve as an
introduction to this area. We start with a discussion of exploitation
primitives, which can be useful when discussing threat models. We then continue
with a more detailed discussion of the various types of vulnerabilities, along
with their mitigations, presented in a rough chronological order of their
appearance (and therefore complexity).

## Exploitation primitives
\missingcontent{Discuss exploitation primitives}

## Stack overflows
\missingcontent{Describe stack overflows and mitigations}

## Code reuse attacks
\missingcontent{Discuss ROP, JOP, COOP and mitigations (ASLR, CFI etc)}

## Non-control data exploits
\missingcontent{Discuss data-oriented programming and other attacks}

## Hardware support for protection against memory vulnerabilities
\missingcontent{Describe architectural features for mitigating memory vulnerabilities and for CFI}

## Other issues
\missingcontent{Mention other issues, e.g. sigreturn-oriented programming}

## JIT compiler vulnerabilities
\missingcontent{Write section on JIT compiler vulnerabilities}

# Physical access side-channel attacks

\missingcontent{Write chapter on physical access side-channel attacks.}

# Remote access side-channel attacks

This chapter covers side-channel attacks for which the attacker does not need
physical access to the hardware.\todo{Define side-channel better.}

## Timing attacks

An implementation of a cryptographic algorithm can leak information about the
data it processes if its run time is influenced by the value of the processed
data. Attacks making use of this are called timing attacks\index{timing
attacks}.

The main mitigation against such attacks consists of carefully implementing the
algorithm such that the execution time remains independent of the processed
data. This can be done by making sure that both:

a) The control flow, i.e. the trace of instructions executed, does not change
   depending on the processed data. This guarantees that every time the
   algorithm runs, exactly the same sequence of instructions is executed,
   independent of the processed data.

b) The instructions used to implement the algorithm are from the subset of
   instructions for which the execution time is known to not depend on the data
   values it processes.
   
   For example, in the Arm architecture, the Armv8.4-A
   [DIT extension](https://developer.arm.com/documentation/ddi0595/2021-06/AArch64-Registers/DIT--Data-Independent-Timing)
   guarantees that execution time is data-independent for a subset of the
   AArch64 instructions.

   By ensuring that the extension is enabled and only instructions in the subset
   are used, data-independent execution time is guaranteed.

At the moment, we do not know of a compiler implementation that actively helps
to guarantee both (a) and (b). A great reference giving practical advice on how
to achieve (a), (b) and more security hardening properties specific for
cryptographic kernels is found in [@Pornin2018].

As discussed in [@Pornin2018], when implementing cryptographic algorithms, you
also need to keep cache side-channel attacks in mind, which are discussed in the
[section on cache side-channel attacks](#cache-side-channel-attacks).

## Cache side-channel attacks

\missingcontent{Write section on cache side-channel attacks. See
\href{https://github.com/llsoftsec/llsoftsecbook/pull/24\#issuecomment-930266031}{the first comment on PR24}
for suggestions of what this should contain.}

# Other security topics relevant for compiler developers

\missingcontent{Write chapter with other security topics.}

\missingcontent{Write section on securely clearing memory in C/C++ and undefined behaviour.}

# Appendix: contribution guidelines {-}

\missingcontent{Write chapter on contribution guidelines.
 These should include at least: project locaton on github; how to create pull requests/issues.
 Where do we discuss - mailing list? Grammar and writing style guidelines.
 How to use todos and index.}

\printindex

\listoftodos

# References {-}
::: {#refs}
:::

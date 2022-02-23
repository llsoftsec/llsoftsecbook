---
SPDX-License-Identifier: CC-BY-4.0
copyright:
  - SPDX-FileCopyrightText: © 2021 Arm Limited <kristof.beyls@arm.com>
title: 'Low-Level Software Security for Compiler Developers'
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


## Why an open source book?

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

## A bit of background on memory vulnerabilities

Memory access errors describe memory accesses that, although permitted by a
program, were not intended by the programmer. These types of errors are usually
defined [@Hicks2014] by explicitly listing their types, which include:

  * buffer overflow
  * null pointer dereference
  * use after free
  * use of uninitialized memory
  * illegal free

Memory vulnerabilities are an important class of vulnerabilities that arise due
to these types of errors, and they most commonly occur due to programming
mistakes when using languages such as C/C++. These languages do not provide
mechanisms to protect against memory access errors by default. An attacker can
exploit such vulnerabilities to leak sensitive data or overwrite critical
memory locations and gain control of the vulnerable program.

Memory vulnerabilities have a long history. The [Morris
worm](https://en.wikipedia.org/wiki/Morris_worm) in 1988 was the first widely
publicized attack exploiting a buffer overflow. Later, in the mid-90s, a few
famous write-ups describing buffer overflows appeared [@AlephOne1996]. [Stack
buffer overflows](#stack-buffer-overflows) were mitigated with [stack
canaries](#stack-buffer-overflows) and [non-executable
stacks](#stack-buffer-overflows). The answer was more ingenious ways to bypass
these mitigations: [code reuse attacks](#code-reuse-attacks), starting with
attacks like [return-into-libc](#code-reuse-attacks) [@Solar1997]. Code reuse
attacks later evolved to [Return-Oriented Programming
(ROP)](#code-reuse-attacks) [@Shacham2007] and even more complex techniques.

To defend against code reuse attacks, the [Address Space Layout Randomization
(ASLR)](#code-reuse-attacks) and [Control-Flow Integrity
(CFI)](#code-reuse-attacks) measures were introduced. \todo{Refine section
links used here and in the previous paragraph.} This interaction between
offensive and defensive security research has been essential to improving
security, and continues to this day. Each newly deployed mitigation results in
attempts, often successful, to bypass it, or in alternative, more complex
exploitation techniques, and even tools to automate them.

Memory safe [@Hicks2014] languages are designed with prevention of such
vulnerabilities in mind and use techniques such as bounds checking and
automatic memory management. If these languages promise to eliminate
memory vulnerabilities, why are we still discussing this topic?

On the one hand, C and C++ remain very popular languages, particular in the
implementation of low-level software. On the other hand, programs written in
memory safe languages can themselves be vulnerable to memory errors as a result
of bugs in how they are implemented, e.g. a bug in their compiler. Can we fix
the problem by also using memory safe languages for the compiler and runtime
implementation? Even if that were as simple as it sounds, unfortunately there
are types of programming errors that these languages cannot protect against.
For example, a logical error in the implementation of a compiler or runtime for
a memory safe language can lead to a memory access error not being detected. We
will see examples of such logic errors in compiler optimizations in a [later
section](#jit-compiler-vulnerabilities).

Given the rich history of memory vulnerabilities and mitigations and the active
developments in this area, compiler developers are likely to encounter some of
these issues over the course of their careers. This chapter aims to serve as an
introduction to this area. We start with a discussion of exploitation
primitives, which can be useful when analyzing threat models \todo{Discuss
threat models elsewhere in book and refer to that section here}. We then
continue with a more detailed discussion of the various types of
vulnerabilities, along with their mitigations, presented in a rough
chronological order of their appearance, and, therefore, complexity.

## Exploitation primitives

Newcomers to the area of software security may find themselves lost in many
blog posts and other publications describing specific memory
vulnerabilities and how to exploit them. Two very common, yet unfamiliar to a
newcomer, terms that appear in such publications are _read primitive_ and
_write primitive_. In order to understand memory vulnerabilities and be able to
design effective mitigations, it's important to understand what these terms
mean, how these primitives could be obtained by an attacker, and how they can
be used.

An _exploit primitive_\index{exploit primitive} is a mechanism that allows an
attacker to perform a specific operation in the memory space of the
victim program. This is done by providing specially crafted input to the
victim program.

A _write primitive_\index{write primitive} gives the attacker some level of
write access to the victim's memory space.  The value written and the address
written to may be controlled by the attacker to various degrees. The primitive,
for example, may allow:

* writing a fixed value to an attacker-controlled address, or
* writing to an address consisting of a fixed base and an attacker-controlled
  offset limited to a specific range (e.g. a 32-bit offset)\todo{Consider
  describing in more detail why the range limitation matters}, or
* writing to an attacker-controlled base address with a fixed offset.

Primitives can be further classified according to more detailed properties.
See slide 11 of [@Miller2012] for an example.

The most powerful version of a write primitive is an _arbitrary write_
primitive, where both the address and the value are fully controlled by the
attacker.

A _read primitive_\index{read primitive}, respectively, gives the attacker read
access to the victim's memory space. The address of the memory location
accessed will be controlled by the attacker to some degree, as for the write
primitive. A particularly useful primitive is an _arbitrary read_ primitive, in
which the address is fully controlled by the attacker.

The effects of a write primitive are perhaps easier to understand, as it
has obvious side-effects: a value is written to the victim program's memory.
But how can an attacker observe the result of a read primitive?

This depends on whether the attack is interactive or non-interactive [@Hu2016].

* In an _interactive attack_\index{interactive attack}, the attacker gives
  malicious input to the victim program. The malicious input causes the victim
  program to perform the read the attacker instructed it to, and to output
  the results of that read. This output could be any kind of output, for
  example a network packet that the victim transmits. The attacker can observe
  the result of the read primitive by looking at this output, for example
  parsing this network packet. This process then repeats: the attacker sends
  more malicious input to the victim, observes the output and prepares the next
  input. You can see an example of this type of attack in
  [@Beer2020], which describes a zero-click radio proximity exploit.
* In a _non-interactive (one-shot) attack_\index{non-interactive (one-shot)
  attack}, the attacker provides all malicious input to the victim program at
  once. The malicious input triggers multiple primitives one after the other,
  and the primitives are able to observe the effects of the preceding
  operations through the victim program's state. The input could be, for
  example, in the form of a JavaScript program [@Groß2020], or a PDF file
  pretending to be a GIF [@Beer2021].

\todo{The references in this section describe complicated modern exploits.
Consider linking to simpler exploits, as well as some tutorial-level material.}

How does an attacker obtain these kinds of primitives in the first place?  The
details vary, and in some cases it takes a combination of many techniques, some
of which are out of scope for this book. But we will be describing a few of
them in this chapter. For example a stack buffer overflow results in a
(restricted) write primitive when the input size exceeds what the program
expected.

As part of an attack, the attacker will want to execute each primitive more
than once, since a single read or write operation will rarely be enough to
achieve their end goal (more on this later). How can primitives be combined
to perform multiple reads/writes?

In the case of an interactive attack, preparing and sending input to the victim
program and parsing the output of the victim program are usually done in an
external program that drives the exploit. The attacker is free to use a
programming language of their choice, as long as they can interact with the
victim program in it. Let's assume, for example, an exploit program in C,
communicating with the victim program over TCP. In this case, the primitives
are abstracted into C functions, which prepare and send packets to the victim,
and parse the victim's responses. Using the primitives is then as simple as
calling these functions. These calls can be easily combined with arbitrary
computations, all written in C, to form the exploit.

For this cycle of repeated input/output interactions to work, the state of the
victim program must not be lost between the different iterations of providing
input and observing output. In other words, the victim process must not be
restarted. 

It's interesting to note that while the read/write primitives consist of
carefully constructed inputs to the victim program, the attacker can view these
inputs as *instructions* to the victim program. The victim program effectively
implements an interpreter unintentionally, and the attacker can send instructions
to this interpreter. This is explored further in [@Dullien2020].

In the case of a non-interactive attack, all computation happens within the
victim program. The duality of input data and code is even more obvious in this
case, as the malicious input to the victim can be viewed as the exploit code.
There are cases for which the input is obviously interpreted as code by the
victim application as well, as in the case of a JavaScript program given as
input to a JavaScript engine. In this case, the read/write primitives would
be written as JavaScript functions, which when called have the unintended
side-effect of accessing arbitrary memory that a JavaScript program is not
supposed to have access to.  The primitives can be chained together with
arbitrary computations, also expressed in JavaScript.

There are, however, cases where the correspondence between data and code isn't
as obvious. For example, in [@Beer2021], the malicious input consists of a PDF
file, masquerading as a GIF. Due to an integer overflow bug in the PDF decoder,
the malicious input leads to an unbounded buffer access, therefore to an
arbitrary read/write primitive. In the case of JavaScript engine exploitation,
the attacker would normally be able to use JavaScript operations and perform
arbitrary computations, making exploitation more straightforward. In this case,
there are no scripting capabilities officially supported. The attackers,
however, take advantage of the compression format intricacies to implement a
small computer architecture, in thousands of simple commands to the decoder.
In this way, they effectively _introduce_ scripting capabilities and are able
to express their exploit as a program to this architecture.

So far, we have described read/write primitives. We have also discussed how an
attacker might perform arbitrary computations:
  * in an external program in the case of interactive attacks, or
  * by using scripting capabilities (whether originally supported or
    introduced by the attacker) in non-interactive attacks.
Assuming an attacker has gained these capabilities, how can they use them to
achieve their goals?

The ultimate goal of an attacker may vary: it may be, among other things,
getting access to a system, leaking sensitive information or bringing down a
service. Frequently, a first step towards these wider goals is arbitrary code
execution\index{arbitrary code execution} within the victim process. We have
already mentioned that the attacker will typically have arbitrary computation
capabilities at this point, but arbitrary code execution also involves things
like calling arbitrary library functions and performing system calls.

Some examples of how the attacker may use the obtained primitives:

* Leak information, such as pointers to specific data structures or code,
  or the stack pointer.
* Overwrite the stack contents, e.g. to perform a [ROP attack](#code-reuse-attacks).
* Overwrite non-control data, e.g. authorization state. Sometimes this
  step is sufficient to achieve the attacker's goal, bypassing the need for
  arbitrary code execution.

Once arbitrary code execution is achieved, the attacker may need to exploit
additional vulnerabilities in order to escape a process sandbox, escalate
privilege, etc. Such vulnerability chaining is common, but for the
purposes of this chapter we will focus on:

* Preventing memory vulnerabilities in the first place, thus stopping
  the attacker from obtaining powerful read/write primitives.
* Mitigating the effects of read/write primitives, e.g. with mechanisms
  to maintain [Control-Flow Integrity (CFI)](#code-reuse-attacks).

## Stack buffer overflows
\missingcontent{Describe stack buffer overflows and mitigations}

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

# Covert channels and side-channels

A large class of attacks make use of so-called side-channels, which are defined
below. The class is so big that in this book we devote the next two chapters to
such attacks. Side-channels have enough complexity to discuss them separately
in this chapter. This chapter describes the mechanisms used to make
communication happen through side-channels. The next two chapters explore how
attacks are constructed that use side-channels.

Side-channels and covert channels are closely related. Both side-channels and
covert channels are communication channels between two entities in a system,
where the entities are not supposed to be allowed to communicate that way.

A **covert channel**\index{covert channel} is such a channel where both
entities intent to communicate through the channel.  A
**side-channel**\index{side-channel} is a such a channel where one end is the
victim of an attack using the channel.

In other words, the difference between a covert channel and a side-channel is
whether both entities intent to communicate, in which case we talk about a
covert channel. If one entity does not intent to communicate, but the other
entity nonetheless extracts some data from the first, it is called a
side-channel attack. The entity not intending to communicate, and hence being
attacked, is called the victim\index{victim}.

The rest of this chapter mostly describes a variety of common covert channel
mechanisms. It does not aim to differentiate much on whether both ends intend to
cooperate on the communication, or whether one end is a victim under attack of
the other end.

In the next few sections we'll explore a common few channels that can be used as
covert channels.

## Cache covert channels

[Caches](https://en.wikipedia.org/wiki/Cache_(computing))\index{cache} are used
in almost every computing system. They are small and much faster memories than
the main memory. They aim to automatically keep frequently used data accessed
by programs, so that average memory access time improves. Various techniques
exist where a covert communication can happen between processes that share a
cache, without the processes having rights to read or write to the same memory
locations.  To understand how these techniques work, one needs to understand
typical organization and operation of a cache.

### Typical CPU cache architecture

There is a wide variety in
[CPU cache micro-architecture](https://en.wikipedia.org/wiki/CPU_cache) details,
but the main characteristics that are important to set up a covert channel tend
to be similar across most popular implementations.

Caches are small and much faster memories than the main memory that aim to keep
a copy of the data at the most frequently accessed main memory addresses. The
set of addresses that are used most frequently changes quickly over time as a
program executes. Therefore, the addresses that are present in CPU caches also
evolve quickly over time. The content of the cache may change with every
executed read or write instruction.

On every read and write instruction, the cache micro-architecture looks up if
the data for the requested address happens to be present in the cache. If it is,
the CPU can continue executing quickly; if not, dependent operations will have
to wait until the data returns from the much slower main memory. A typical
access time is 3 to 5 CPU cycles for the fastest cache on a CPU versus hundreds
of cycles for a main memory access.\index{memory access time}

Most systems have multiple levels of cache\index{multi-level cache}, each with a
different trade-off between cache size\index{cache size} and access
time\index{cache access time}. Some typical characteristics might be:

* L1 (level 1) cache, 32kB in size, with an access time of 4 cycles.
* L2 cache, 256Kb in size, with an access time of 10 cycles.
* L3 cache, 16MB in size, with an access time of 40 cycles.
* Main memory, gigabytes in size, with an access time of more than 100 cycles.

![Illustration of cache levels in a typical system](img/CacheLevels){ width=40% }

If data is not already present in a cache layer, it is typically stored there
after it has been fetched from a slower cache level or main memory. This is
often a good decision to make as there's a high likelihood the same address will
be accessed by the program soon after. This high likelihood is known as the
[principle of locality](https://en.wikipedia.org/wiki/Locality_of_reference)\index{principle
of locality}\index{locality of reference}.

Data is stored and transferred between cache levels in blocks of aligned memory.
Such a block is called a cache block\index{cache block} or cache
line\index{cache line}. Typical sizes are 32, 64 or 128 bytes per cache line.

When data that wasn't previously in the cache needs to be stored in the cache,
most of the time, room has to be made for it by removing, or
evicting\index{cache eviction}, some other address/data from it. How that choice
gets made is decided by the
[cache replacement policy](https://en.wikipedia.org/wiki/Cache_replacement_policies)\index{cache
replacement policy}. Popular replacement algorithms are Least Recently Used
(LRU)\index{LRU replacement policy}, Random\index{random replacement policy} and
pseudo-LRU\index{pseudo-LRU replacement policy}. As the names suggest, LRU
evicts the cache line that is least recently used; random picks a random cache
line; and pseudo-LRU approximates choosing the least recently used line.

If an address can be stored in all locations available in the cache, the cache
is fully-associative\index{fully-associative cache}. Most caches are however not
fully-associative, as it's too costly to implement. Instead, most caches are
set-associative\index{set-associative cache}. In an N-way set-associative cache,
a specific main memory address can only be stored in one of N cache locations.
For example, if an address can potentially be stored in one of 2 locations, the
cache is said to be 2-way set-associative. If it can be stored in one of 4
locations, it's called 4-way set-associative, and so on. When an address can
only be stored in one location in the cache, it is said to be
direct-mapped\index{direct-mapped cache}, rather than 1-way set-associative.
Typical organizations are direct-mapped, 2-way, 4-way, 8-way, 16-way or 32-way
set-associative.

\missingcontent{Explain indexing mechanism used; from address bits to index in cache.}

\missingcontent{Also explain cache coherency \index{cache coherency}?}
\missingcontent{Also say something about TLBs and prefetching?}

### General operation of cache covert channels

## Timing covert channels

## Resource contention channels

## Channels making use of aliasing in branch predictors and other predictors

\missingcontent{Should we also discuss more "covert" channels here such as power analysis, etc?}

# Physical access side-channel attacks

\missingcontent{Write chapter on physical access side-channel attacks.}

# Remote access side-channel attacks

This chapter covers side-channel attacks for which the attacker does not need
physical access to the hardware.

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

<!-- markdown-link-check-disable -->
\missingcontent{Write section on cache side-channel attacks. See
\href{https://github.com/llsoftsec/llsoftsecbook/pull/24\#issuecomment-930266031}{the first comment on PR24}
for suggestions of what this should contain.}
<!-- markdown-link-check-enable-->

# Supply chain attacks

A software _supply chain attack_ occurs when an attacker interferes with the
software development or distribution processes with the intention to impact
users of that software.

Supply chain attacks and their possible mitigations are not specific to
compilers. However, compilers are an attractive target for attack because they
are widely deployed to developers, in continuous integration systems and as
JITs. Also, an infected compiler has the possibility to make a much larger
impact if it can silently spread the infection to other software created with
or run using it.

This chapter explores the history of supply chain attacks that involve
compilers and what can be done to prevent them.

## History of supply chain attacks

As far back as 1974 Karger & Schell theorized about an attack on the Multics
operating system via the PL/I compiler [@Karger1974]. In this attack, a trap
door is inserted into the compiler, which then injects malicious code into
generated object code. Furthermore, the trap door could be designed to reinsert
itself into the compiler binary so that future compilers are silently infected
without needing changes to their source code. This attack method was
subsequently popularised by Ken Thompson in his 1984 ACM Turing Award
acceptance speech _Reflections on Trusting Trust_ [@Thompson1984].

If these cases seem far-fetched then consider that there have been several real
examples of supply chain attacks on development tools.

Induc is a family of viruses that infects a pre-compiled library in the Delphi
toolchain with malicious code [@Gostev2009]. When Delphi compiles a project the
malicious library is included into the resulting executable, thus enabling the
virus to spread. The virus was first detected in 2009 and was circulating
undetected for at least a year beforehand. Several popular applications are
known to have been infected, including a chat client and a media player.
Overall, in excess of a hundred thousand infected computers were detected
world-wide by anti-virus solutions.

XcodeGhost is the name given to malware first detected in 2015 that infected
thousands of iOS applications [@Cox2015]. The source of the infection was
tracked down to a trojanized version of Xcode tools. The malware exists
in an extra object file within the Xcode tools and is silently linked into each
application as it is built. File sharing sites were used to spread the
trojanized Xcode tools to unwitting developers.

A trojanized linker was found to be involved in a supply chain attack discovered
in 2017 named ShadowPad [@Greenberg2019]. Some instances of the attack were
perpetrated using a trojanized Visual Studio linker that silently incorporates
a malicious library into applications as they are built. Related attacks named
CCleaner and ShadowHammer used the same approach of a trojanized linker to
infect built applications. Infected applications from these attacks were
distributed to millions of users world-wide.

These cases highlight that attacks on compilers, and especially linkers and
libraries, are a viable route to silently infect many other applications, and
there is no doubt that there will be more such attacks in the future. Let us
now explore what we can do about these.

\missingcontent{Explain how these vulnerabilities arise and how to mitigate them.}

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

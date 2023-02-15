# llsoftsecbook: a book on Low-Level Software Security for Compiler Developers

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![Build book with docker container CI](https://github.com/llsoftsec/llsoftsecbook/actions/workflows/main.yml/badge.svg)](https://github.com/llsoftsec/llsoftsecbook/actions/workflows/main.yml)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-13-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

This book aims to provide a structured, broad overview of all attacks and
security hardening techniques relevant for code generation tools.

## Purpose

Compilers, assemblers and similar tools generate all the binary code that
processors execute. Therefore, they play a crucial role in hardening binaries
against security threats.

The variety of attacks and hardening techniques has been rising sharply, and it
is becoming difficult to maintain a good broad basic understanding of all of
them.

The purpose of this book is to help every compiler developer that needs to learn
about software security relevant to compilers. It aims to achieve that by
providing a description of all relevant high-level aspects of attacks,
vulnerabilities, mitigations and hardening techniques. For further details, this
book provides pointers to material on specific techniques.

Even though the focus is on compiler developers, we expect that this book will
also be useful to other people working on low-level software.

## Why an open source book?

The idea for this book emerged out of a frustration of not finding a good
overview on this topic. Kristof Beyls and Georgia Kouveli, compiler engineers
working on security features from time to time, wished a book like this would
exist. After not finding such a book, we decided to try and write one ourselves.
We immediately realized that we do not have all necessary expertise ourselves to
complete such a daunting task. So we decided to try and create this book in an
open source style, seeking contributions from many experts.

As you read this, the book remains unfinished. This book may well never be
finished, as new vulnerabilities continue to be discovered regularly. Our hope
is that developing the book as an open source project will allow it to continue
to evolve and improve. It being open source increases the likelihood that it
remains relevant as new vulnerabilities and mitigations emerge.

Kristof and Georgia are far from experts on all possible vulnerabilities. So
what is the plan to get high quality content to cover all relevant topics? It is
two-fold.

First, by studying specific topics, we hope to gain enough knowledge to write
up a good summary for this book.

Second, we very much invite and welcome contributions. If you're interested
in potentially contributing content, please let us know.

As a reader, you can also contribute to making this book better. We highly
encourage feedback, both positive and constructive criticisms. We prefer
feedback to be received through the GitHub communication channels
[Issues](https://github.com/llsoftsec/llsoftsecbook/issues)
and [Discussions](https://github.com/llsoftsec/llsoftsecbook/discussions)


## Live version

A live top-of-main version of the book is available as a webpage at
<https://llsoftsec.github.io/llsoftsecbook>. A
[PDF](https://llsoftsec.github.io/llsoftsecbook/book.pdf) is also available.


## Build instructions

You can build the book by running

```console
$ make all
```

This requires pandoc, latex and necessary latex packages to be installed. The
easiest way to make sure you build the book with the right versions of those
tools is to use the script build_with_docker.sh:

```console
$ ./build_with_docker.sh
```

This builds a docker container with the exact versions of pandoc, latex and
necessary extra packages; and builds the book using that container.

You'll find the PDF and HTML versions of the book in build/book.pdf and
build/book.html if the build finishes successfully.

## Contributing

Please find contribution guidelines in <https://github.com/llsoftsec/llsoftsecbook/blob/main/contributing.md>.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/kbeyls"><img src="https://avatars.githubusercontent.com/u/19591946?v=4?s=100" width="100px;" alt="Kristof Beyls"/><br /><sub><b>Kristof Beyls</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=kbeyls" title="Tests">⚠️</a> <a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=kbeyls" title="Code">💻</a> <a href="#content-kbeyls" title="Content">🖋</a> <a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=kbeyls" title="Documentation">📖</a> <a href="#ideas-kbeyls" title="Ideas, Planning, & Feedback">🤔</a> <a href="#infra-kbeyls" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="https://github.com/llsoftsec/llsoftsecbook/pulls?q=is%3Apr+reviewed-by%3Akbeyls" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://tubafranz.me/"><img src="https://avatars.githubusercontent.com/u/25690309?v=4?s=100" width="100px;" alt="Francesco Petrogalli"/><br /><sub><b>Francesco Petrogalli</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/pulls?q=is%3Apr+reviewed-by%3Afpetrogalli" title="Reviewed Pull Requests">👀</a> <a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=fpetrogalli" title="Code">💻</a> <a href="#infra-fpetrogalli" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/g-kouv"><img src="https://avatars.githubusercontent.com/u/6901396?v=4?s=100" width="100px;" alt="g-kouv"/><br /><sub><b>g-kouv</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/pulls?q=is%3Apr+reviewed-by%3Ag-kouv" title="Reviewed Pull Requests">👀</a> <a href="#ideas-g-kouv" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=g-kouv" title="Code">💻</a> <a href="#content-g-kouv" title="Content">🖋</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/statham-arm"><img src="https://avatars.githubusercontent.com/u/54840944?v=4?s=100" width="100px;" alt="Simon Tatham"/><br /><sub><b>Simon Tatham</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/pulls?q=is%3Apr+reviewed-by%3Astatham-arm" title="Reviewed Pull Requests">👀</a> <a href="#ideas-statham-arm" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=statham-arm" title="Code">💻</a> <a href="#content-statham-arm" title="Content">🖋</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/sam-ellis"><img src="https://avatars.githubusercontent.com/u/6695726?v=4?s=100" width="100px;" alt="Sam Ellis"/><br /><sub><b>Sam Ellis</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=sam-ellis" title="Code">💻</a> <a href="#content-sam-ellis" title="Content">🖋</a> <a href="https://github.com/llsoftsec/llsoftsecbook/issues?q=author%3Asam-ellis" title="Bug reports">🐛</a> <a href="#ideas-sam-ellis" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/llsoftsec/llsoftsecbook/pulls?q=is%3Apr+reviewed-by%3Asam-ellis" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.lyndonfawcett.com"><img src="https://avatars.githubusercontent.com/u/5150703?v=4?s=100" width="100px;" alt="Lyndon Fawcett"/><br /><sub><b>Lyndon Fawcett</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/issues?q=author%3Alyndon160" title="Bug reports">🐛</a> <a href="#ideas-lyndon160" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/JLouisKaplan-Arm"><img src="https://avatars.githubusercontent.com/u/90251161?v=4?s=100" width="100px;" alt="Jonathan Louis Kaplan"/><br /><sub><b>Jonathan Louis Kaplan</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/issues?q=author%3AJLouisKaplan-Arm" title="Bug reports">🐛</a> <a href="#ideas-JLouisKaplan-Arm" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=JLouisKaplan-Arm" title="Code">💻</a> <a href="https://github.com/llsoftsec/llsoftsecbook/pulls?q=is%3Apr+reviewed-by%3AJLouisKaplan-Arm" title="Reviewed Pull Requests">👀</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/jacobbramley"><img src="https://avatars.githubusercontent.com/u/5206553?v=4?s=100" width="100px;" alt="Jacob Bramley"/><br /><sub><b>Jacob Bramley</b></sub></a><br /><a href="#ideas-jacobbramley" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/joseph-yiu"><img src="https://avatars.githubusercontent.com/u/77114984?v=4?s=100" width="100px;" alt="Joseph Yiu"/><br /><sub><b>Joseph Yiu</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=joseph-yiu" title="Code">💻</a> <a href="#content-joseph-yiu" title="Content">🖋</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Arnaud-de-Grandmaison-ARM"><img src="https://avatars.githubusercontent.com/u/24225823?v=4?s=100" width="100px;" alt="Arnaud de Grandmaison"/><br /><sub><b>Arnaud de Grandmaison</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/pulls?q=is%3Apr+reviewed-by%3AArnaud-de-Grandmaison-ARM" title="Reviewed Pull Requests">👀</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Fare9"><img src="https://avatars.githubusercontent.com/u/13202760?v=4?s=100" width="100px;" alt="Fare9"/><br /><sub><b>Fare9</b></sub></a><br /><a href="#ideas-Fare9" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://homepages.dcc.ufmg.br/~fernando/"><img src="https://avatars.githubusercontent.com/u/367846?v=4?s=100" width="100px;" alt="Fernando Magno Quintão Pereira"/><br /><sub><b>Fernando Magno Quintão Pereira</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/issues?q=author%3Apronesto" title="Bug reports">🐛</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/thanks"><img src="https://avatars.githubusercontent.com/u/1121545?v=4?s=100" width="100px;" alt="Thanks"/><br /><sub><b>Thanks</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/pulls?q=is%3Apr+reviewed-by%3AThanks" title="Reviewed Pull Requests">👀</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## License

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This book is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

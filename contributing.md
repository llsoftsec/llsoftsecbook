# Welcome to the llsoftsecbook contributing guide

We are looking forward to your contributions and are happy you found your way to
this contributing guide. Thank you for investing your time in contributing to
our project!



## What types of contributions are we looking for?

We are looking for a variety of contributions, including, but not limited, to:
- Reports on how to improve spelling, grammar, style or other linguistic aspects
  of the book.
- Ideas for new content, or for how to present existing content in an
  alternative way to make it easier to digest.
- Patches improving existing content or adding new content.
- Improvements to the scripts in this project.
- Improvements to the look-and-feel of the produced HTML and PDF output.
- Any other improvements.

## What is the vision for the project?

See https://github.com/llsoftsec/llsoftsecbook/blob/main/README.md#purpose

## Submitting ideas for new content, how to improve language, ...

Please raise an issue at https://github.com/llsoftsec/llsoftsecbook/issues/. It
may be a good idea to check if there is already an issue for what you're
planning to report.

## Submitting changes

Please send a GitHub Pull Request (read more about
[pull requests](https://docs.github.com/en/github/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)).
Please follow our
[style and coding conventions](#style-and-coding-conventions).

### Copyright and license

The copyright on contributions is not transferred. In other words, contributors
retain copyright on their contributions.

If you're making a contribution for the first time, please check if the
copyright owner is listed in the header under the "copyright:" tag at
https://github.com/llsoftsec/llsoftsecbook/blob/main/book.md?plain=1. If not,
please do add a line with "SPDX-FileCopyrightText" under the "copyright:" header
so that the copyright notices for this project remain well-maintained.

The license used for this project is
https://creativecommons.org/licenses/by/4.0/.

### Planning changes

If you're planning to fix a non-trivial reported issue or to add new content,
please do let us know. This could be as simple as assigning the issue for it to
yourself. Or you could also comment on the relevant issue, or start a
[discussion thread](https://github.com/llsoftsec/llsoftsecbook/discussions).

If you are looking for a good first issue to work on, the issues labeled with
"[good
first issue](https://github.com/llsoftsec/llsoftsecbook/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)" may be good candidates.

## Other ways to get in touch

If you'd like to get in touch and Issues do not seem to be the right way to
communicate, please use [Discussions](<https://github.com/llsoftsec/llsoftsecbook/discussions>).

## Style and coding conventions

- We use [pandoc markdown](https://pandoc.org/MANUAL.html#pandocs-markdown).
- We favor incremental development of the book. Specifically,
  - We aim for individual commits adding new content to not be overly large, but
    remain focussed on a specific topic.
  - We aim for commits fixing style, spelling or other language issues to fix
    one general issue at a time.
  - When writing new content, do use the ``\todo`` macro to indicate if some
    detail should or could be added later. Similar to how TODO or FIXME comments
    are used in code projects, we use ``\todo`` macros to indicate an
    improvement that should be made later. We hope that by using ``\todo``,
    contributors will wrestle a bit less with writer's block. For now, to-dos
    are only visible in the PDF output, where they are put in the margin. An
    example to-do looks as follows in the source:
    ``\todo{Also support \todo in the HTML output.}.``

    For completely missing sections of contents, use
    ``\missingcontent{A description of the missing content goes here.}``

- For now, we keep all text content of the book in a single
  [book.md](https://github.com/llsoftsec/llsoftsecbook/blob/main/book.md) file.
- When adding new content, please remember to:
  - Spell check your contributions. We use US English spelling.
  - Add \index as needed to make sure the index of the book remains up-to-date.
- If the copyright owner of what you're adding is not already listed in the
  header of
  [book.md](https://github.com/llsoftsec/llsoftsecbook/blob/main/book.md) under
  'copyright:', please add a SPDX-FileCopyrightText item.


### General style and grammar conventions

- We use US English spelling.
- We favor simple language over complicated language.
- If in doubt, we'll consult the
  [Chicago Manual of Style](https://www.chicagomanualofstyle.org/home.html) as
  it is a de facto standard.

### Diagrams and images

When diagrams or images are needed in the book, we encourage drawing them with
https://github.com/jgraph/drawio-desktop/. Inkscape can also be used to draw
them, but may be a bit more cumbersome to use for technical diagrams.

We use SVG as the image source format. The sources are stored in the `img`
sub-directory.

For the HTML output, the SVG images are included as is.  For the PDF output,
the SVGs are automatically converted to PDFs.  If you edit or add an SVG image,
make sure to check the PDF output to see if the conversion worked as expected.
A common issue that can happen during conversion to PDF is explained at
https://www.diagrams.net/doc/faq/svg-export-text-problems.

## How to build/test
- See <https://github.com/llsoftsec/llsoftsecbook/blob/main/README.md#build-instructions>.
- The project has [CI
  setup](https://github.com/llsoftsec/llsoftsecbook/actions/workflows/main.yml),
  which checks that the PDF and HTML versions of the book build without error
  messages. It also publishes the top-of-tree version of the book at
  <https://llsoftsec.github.io/llsoftsecbook/>.

## Attribution

We follow <https://allcontributors.org/> to recognize all contributors.

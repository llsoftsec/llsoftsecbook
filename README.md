# llsoftsecbook
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-2-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->


## Build instructions

You can build the book by running

```console
$ make all
```

This requires pandoc, latex and necessary latex packages to be installed.
A probably less issue-prone way to run the build is to use the script
build_pdfs_with_docker.sh:

```console
$ ./build_pdfs_with_docker.sh
```

This builds a docker container with the exact versions of pandoc, latex and
necessary extra packages; and builds the book using that container.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/kbeyls"><img src="https://avatars.githubusercontent.com/u/19591946?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Kristof Beyls</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=kbeyls" title="Tests">⚠️</a> <a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=kbeyls" title="Code">💻</a> <a href="#content-kbeyls" title="Content">🖋</a> <a href="https://github.com/llsoftsec/llsoftsecbook/commits?author=kbeyls" title="Documentation">📖</a> <a href="#ideas-kbeyls" title="Ideas, Planning, & Feedback">🤔</a> <a href="#infra-kbeyls" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a></td>
    <td align="center"><a href="https://github.com/g-kouv"><img src="https://avatars.githubusercontent.com/u/6901396?v=4?s=100" width="100px;" alt=""/><br /><sub><b>g-kouv</b></sub></a><br /><a href="https://github.com/llsoftsec/llsoftsecbook/pulls?q=is%3Apr+reviewed-by%3Ag-kouv" title="Reviewed Pull Requests">👀</a> <a href="#ideas-g-kouv" title="Ideas, Planning, & Feedback">🤔</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
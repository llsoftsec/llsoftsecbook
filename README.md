# llsoftsecbook


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

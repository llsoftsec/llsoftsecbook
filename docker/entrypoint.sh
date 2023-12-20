#!/bin/bash

cd /src
ls -al
echo pandoc version:
pandoc --version
sh -c "make $*"

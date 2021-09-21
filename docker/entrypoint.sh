#!/bin/sh

cd /src
echo $PWD
ls -al
sh -c "make $*"

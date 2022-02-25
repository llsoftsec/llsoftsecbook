#!/bin/sh
readonly uid="$(id -u)"
readonly gid="$(id -g)"
docker build -t llsoftsecbook_build docker && docker run --rm --user="${uid}":"${gid}" --mount type=bind,source="$(pwd)",target=/src llsoftsecbook_build all

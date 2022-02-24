#!/bin/sh
readonly script_path="$0"
readonly uid="$(stat -c "%u" "${script_path}")"
readonly gid="$(stat -c "%g" "${script_path}")"
docker build -t llsoftsecbook_build docker && docker run --rm --user="${uid}":"${gid}" --mount type=bind,source="$(pwd)",target=/src llsoftsecbook_build all

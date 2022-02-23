readonly base="$(dirname "${BASH_SOURCE[0]}")"
readonly uid="$(stat -c "%u" $base)"
readonly gid="$(stat -c "%g" $base)"
docker build -t llsoftsecbook_build docker && docker run --rm --user=${uid}:${gid} --mount type=bind,source="$(pwd)",target=/src llsoftsecbook_build all

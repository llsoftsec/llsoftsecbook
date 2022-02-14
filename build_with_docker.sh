build_args="--build-arg uname=${USER} --build-arg uid=$(id -u)"
docker build $build_args -t llsoftsecbook_build docker
docker run --rm --mount type=bind,source="$(pwd)",target=/src llsoftsecbook_build all

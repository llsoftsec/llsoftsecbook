docker build -t llsoftsecbook_build docker && docker run --rm --mount type=bind,source="$(pwd)",target=/src llsoftsecbook_build all

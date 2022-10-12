#!/bin/zsh
# Ok so the file was misnamed, sometimes I do functions here too


fly-devcourse() {
    env ASDF_CONCOURSE_VERSION=5.7.0 fly -t devcourse $@
}

orcrun() {
    docker run -it -v ~/code/work:/root/work -v ~/.gitconfig:/root/.gitconfig -v ~/.chef:/root/.chef --platform=linux/amd64 docker-chaos.ilabs.io/blackwidow/centos7-orc $@
}

myrun() {
    docker run -it -v ~/code/work:/root/work -v ~/.gitconfig:/root/.gitconfig -v ~/.chef:/root/.chef --platform=linux/amd64 mydocker $@
}

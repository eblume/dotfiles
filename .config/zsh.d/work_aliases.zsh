#!/bin/zsh
# Ok so the file was misnamed, sometimes I do functions here too


fly-devcourse-main() {
    env ASDF_CONCOURSE_VERSION=5.7.0 fly -t devcourse-main $@
}

fly-devcourse-unittests-ops() {
    env ASDF_CONCOURSE_VERSION=5.7.0 fly -t devcourse-unittests-ops $@
}

fly-prodcourse() {
    env ASDF_CONCOURSE_VERSION=5.7.0 fly -t prodcourse $@
}

fly-govcourse() {
    env ASDF_CONCOURSE_VERSION=5.7.0 fly -t govcourse $@
}

export PATH="$PATH:$HOME/code/work/eblume/ilodevops/bin"

#!/bin/zsh
# Ok so the file was misnamed, sometimes I do functions here too


fly-devcourse() {
    env ASDF_CONCOURSE_VERSION=5.7.0 fly -t devcourse $@
}

fly-prodcourse() {
    env ASDF_CONCOURSE_VERSION=5.7.0 fly -t prodcourse $@
}

fly-govcourse() {
    env ASDF_CONCOURSE_VERSION=5.7.0 fly -t govcourse $@
}

orcrun() {
    docker run -it -v ~/code/work:/root/work -v ~/.gitconfig:/root/.gitconfig -v ~/.chef:/root/.chef --platform=linux/amd64 docker-chaos.ilabs.io/blackwidow/centos7-orc $@
}

ilodevops-dev() {
    ilodevops-core ilodevops-dev $@
}

ilodevops-prod() {
    ilodevops-core ilodevops-prod $@
}

ilodevops-gov() {
    ilodevops-core ilodevops-gov $@
}

ilodevops-core() {
    if [ -z `ilodevops-compose ps -q $1` ] || [ -z `docker ps -q --no-trunc | grep $(ilodevops-compose ps -q $1)` ]; then
        echo "service '$1' is not running. Have you run 'ilodevops-compose up'?"
    else
        ilodevops-compose run $@
    fi
}

ilodevops-compose() {
    docker compose -f ~/code/work/eblume/ilodevops/compose.yaml $@
}

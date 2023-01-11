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


# LOCAL ILODEVOPS - experimental - for using knife.rb from ilodevops, but outside of containers. This is NOT the source
# of default ilodevops config!
export ILODEVOPS_USER='eblume'
export CHEF_SERVER_URL='https://chef-dev.ilabs.io'
export CHEF_ADMINS='abondarenko,adias,akatida,eblume,gbeasley,jprathipati,jterry,kgo,kkim,ops-ci,pmoore,zcrownover'
export ILODEVOPS_CODE="$HOME/code/work"

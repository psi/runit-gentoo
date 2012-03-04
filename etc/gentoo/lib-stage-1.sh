#!/bin/dash

load_conf () {
    . /etc/runit/conf.d/"${1}"
}

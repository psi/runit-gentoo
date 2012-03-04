#!/bin/dash
. /etc/runit/lib-stage-1.sh
load_conf hostname
hostname $hostname

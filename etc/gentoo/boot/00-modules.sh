#!/bin/dash
. /etc/runit/lib-stage-1.sh
load_conf modules
echo "Loading modules..."
for module in ${modules}; do
    modprobe $module
done

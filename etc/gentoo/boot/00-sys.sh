#!/bin/dash
echo "Mounting /sys..."
mount -n -t sysfs -o noexec,nosuid,nodev sysfs /sys

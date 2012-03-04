#!/bin/dash
echo "Mounting /dev..."
mount -n -t tmpfs -o size=128k,mode=0755 tmpfs /dev
echo "Mounting /dev/pts..."
mkdir -p /dev/pts
mount -n -t devpts devpts /dev/pts
echo "Starting mdev..."
sysctl -w kernel.hotplug=/sbin/mdev
mdev -s

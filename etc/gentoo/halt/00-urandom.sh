#!/bin/dash
local urandom_seed=/var/lib/misc/random-seed

echo "Saving random seed..."
local psz=1

if [ -e /proc/sys/kernel/random/poolsize ]; then
    : $(( psz = $(cat /proc/sys/kernel/random/poolsize) / 4096 ))
fi

(	# sub shell to prevent umask pollution
    umask 077
    dd if=/dev/urandom of="$urandom_seed" count=${psz} 2>/dev/null
)

[ 0 -eq $? ] || echo "Failed to save random seed."

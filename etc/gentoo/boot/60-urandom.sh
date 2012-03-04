#!/bin/dash
local urandom_seed=/var/lib/misc/random-seed

save_seed()
{
	local psz=1

	if [ -e /proc/sys/kernel/random/poolsize ]; then
		: $(( psz = $(cat /proc/sys/kernel/random/poolsize) / 4096 ))
	fi

	(	# sub shell to prevent umask pollution
		umask 077
		dd if=/dev/urandom of="$urandom_seed" count=${psz} 2>/dev/null
	)
}

[ -c /dev/urandom ] || exit 0
if [ -f "$urandom_seed" ]; then
    echo "Initializing random number generator..."
    cat "$urandom_seed" > /dev/urandom
    [ $? -eq 0 ] || echo "Error initializing random number generator"
fi
rm -f "$urandom_seed" && save_seed

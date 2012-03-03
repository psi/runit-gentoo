#!/bin/dash

alsastatedir=/var/lib/alsa

echo "Restoring ALSA mixer levels..."

if [ ! -r "${alsastatedir}/asound.state" ] ; then
    echo "No mixer config in ${alsastatedir}/asound.state, you have to unmute your card!"
    exit 0
fi

local cards="$(sed -n -e 's/ *\([[:digit:]]*\) .*/\1/p' /proc/asound/cards)"
local CARDNUM
for cardnum in ${cards}; do
    [ -e /dev/snd/controlC${cardnum} ] || sleep 2
    [ -e /dev/snd/controlC${cardnum} ] || sleep 2
    [ -e /dev/snd/controlC${cardnum} ] || sleep 2
    [ -e /dev/snd/controlC${cardnum} ] || sleep 2
    alsactl -f "${alsastatedir}/asound.state" restore ${cardnum} \
        || echo "Errors while restoring defaults, ignoring"
done

for ossfile in "${alsastatedir}"/oss/card*_pcm* ; do
    [ -e "${ossfile}" ] || continue
    # We use cat because I'm not sure if cp works properly on /proc
    local procfile=${ossfile##${alsastatedir}/oss}
    procfile="$(echo "${procfile}" | sed -e 's,_,/,g')"
    if [ -e /proc/asound/"${procfile}"/oss ] ; then
        cat "${ossfile}" > /proc/asound/"${procfile}"/oss 
    fi
done

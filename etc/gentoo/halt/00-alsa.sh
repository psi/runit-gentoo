#!/bin/dash

alsastatedir=/var/lib/alsa

echo "Storing ALSA mixer levels..."

mkdir -p "${alsastatedir}"
if ! alsactl -f "${alsastatedir}/asound.state" store; then
    echo "Error saving levels."
    exit 1
fi

for ossfile in /proc/asound/card*/pcm*/oss; do
    [ -e "${ossfile}" ] || continue
    local device=${ossfile##/proc/asound/} ; device=${device%%/oss}
    device="$(echo "${device}" | sed -e 's,/,_,g')"
    mkdir -p "${alsastatedir}/oss/"
    cp "${ossfile}" "${alsastatedir}/oss/${device}"
done

#!/bin/dash

echo "Configuring kernel parameters..."
for conf in /etc/sysctl.d/*.conf /etc/sysctl.conf; do
    if [ -r "$conf" ]; then
        echo "Applying $conf..."
        if ! err=$(sysctl -q -p "$conf" 2>&1) ; then
            errs="${errs} ${err}"
            sysctl -q -e -p "${conf}"
        fi
        [ $? -eq 0 ] || echo "$conf failed."
    fi
done

#!/bin/dash
echo "Activating swap..."
swapon -a >/dev/null
exit 0 # If swapon has nothing to do, it errors.

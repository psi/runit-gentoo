#!/bin/dash
local service=`basename \`dirname \\\`pwd\\\`\``
mkdir -p /var/log/runit/${service}
exec svlogd -ttt /var/log/runit/${service}

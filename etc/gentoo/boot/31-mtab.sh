#!/bin/dash
echo "Updating /etc/mtab..."
if ! echo 2>/dev/null >/etc/mtab; then
    echo "/etc/mtab is not updateable"
    exit 0
fi

# With / as tmpfs we cannot umount -at tmpfs in localmount as that
# makes / readonly and dismounts all tmpfs even if in use which is
# not good. Luckily, umount uses /etc/mtab instead of /proc/mounts
# which allows this hack to work.
grep -v "^[^ ]* / tmpfs " /proc/mounts > /etc/mtab

# Remove stale backups
rm -f /etc/mtab~ /etc/mtab~~

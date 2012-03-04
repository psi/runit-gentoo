#!/bin/dash
echo "Deactivating swap devices..."
umount -a -t tmpfs 2>/dev/null
swapoff -a >/dev/null

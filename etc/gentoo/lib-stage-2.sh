#!/bin/dash

wait_for() {
    echo "waiting for ${1}..."
    sv start ${1} || exit 1
}

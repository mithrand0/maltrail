#!/bin/bash
set -e

echo 'Starting compatibility wrapper for maltrail..'

command="${1}"

case "${command}" in
"server.py")
    command="python -u server.py"
    ;;
"sensor.py")
    command="python -u sensor.py"
    ;;
esac

$command "${@:2:9}" > /dev/stdout 2>&1
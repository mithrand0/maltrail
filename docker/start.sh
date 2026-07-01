#!/bin/bash
set -e

# switch to directory
cd "${VENV}"

# check if any trails are found
# if not, place a copy of the included trails in this image
if [[ ! -f /root/.maltrail/trails.csv ]]; then
    echo "Initial trails not found, copying built-in trails.."
    cp -r /root/.maltrail-dist /root/.maltrail
fi

echo "Starting maltrail.."
case "${1}" in
    "server.py")
        exec python server.py
        ;;
    "sensor.py")
        exec python sensor.py
        ;;
    *)
        echo "Usage: $0 <server.py|sensor.py>"
        exit 1
esac
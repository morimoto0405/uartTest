#!/bin/bash

PIN=4

#GPIOエクスポート
if [ ! -d /sys/class/gpio/gpio$PIN ]; then
    echo "$PIN" > /sys/class/gpio/export
fi
echo "in" > /sys/class/gpio/gpio$PIN/direction
echo "Shutdown monitor started..."

#無限ループで監視
while true; do
    VALUE=$(cat /sys/class/gpio/gpio$PIN/value)
    if [ "$VALUE" -eq 1 ]; then
        echo "Power loss detected! Shutting down..."
        sudo shutdown -h now
        break
    fi
    sleep 0.5
done
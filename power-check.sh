#!/bin/bash

set -e

#1 gpiod　のインストール
if ! command -v gpiomon & > /dev/null; then
    echo "gpiod not found. Installing..."
    sudo apt update
    sudo apt install -y gpiod
else
    echo "gpiod already installed."
fi

#2 gpioを監視する準備
PIN=4
CHIP=gpiochip0

# #GPIO4を出力モードに設定し、LOWに
# echo "=== Setting GPIO$PIN mode ==="
# gpioset --mode=timebased $CHIP $PIN=0

#GPIO4のエッジ監視
echo "=== Monitoring GPIO$PIN for power loss ==="
echo "Press Ctrl+C to exit"

gpiomon -t 100 $CHIP $PIN | while read line; do
    echo "Power loss detected!"
    sudo shutdown -h now
done
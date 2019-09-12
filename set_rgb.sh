#!/bin/sh

sudo stty -F /dev/ttyS0 115200
echo "chromamode 0" > /dev/ttyS0

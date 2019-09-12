#!/bin/sh

sudo stty -F /dev/ttyS0 115200
echo "chromamode 1" > /dev/ttyS0

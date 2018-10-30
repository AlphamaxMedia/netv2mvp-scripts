#!/bin/bash

# ONE-COMMAND UPDATE SCRIPT FOR NETV2 FPGA FIRMWARE/GATEWARE
# This is tested against the default installation of NeTV2
# Modifying the location of git repositories or origin remote
# of the repositories is liable to cause the update script to fail.

GIT_DIR=/home/pi/code/netv2-fpga
OCD_SCRIPT_DIR=/home/pi/code/netv2mvp-scripts

printf "Pulling Updated JTAG scripts...\n"
cd $OCD_SCRIPT_DIR
git pull origin master
if [ $? -ne 0 ]
then
    printf "Can't pull update to JTAG scripts. Check network connectivity and confirm git repo at $OCD_SCRIPT_DIR with remote origin of https://github.com/AlphamaxMedia/netv2mvp-scripts.git. Press return to exit.\n"
    read dummy
    exit 1
fi

printf "\n\nPulling updated firmware...\n"
cd $GIT_DIR
git pull origin master
if [ $? -ne 0 ]
then
    printf "Can't pull update to firmware. Check network connectivity and confirm git repo at $GIT_DIR with remote origin of https://github.com/AlphamaxMedia/netv2-fpga.git. Press return to exit.\n"
    read dummy
    exit 1
fi

cd ~

printf "\n\nCheck IDCODE of FPGA...\n"

IDCODE=`sudo openocd -f $OCD_SCRIPT_DIR/idcode.cfg 2>&1 | grep -E -o "tap/device found: [0-9a-z]+" | cut -f3 -d" "`

printf "Got $IDCODE"

if [ "$IDCODE" = "0x0362d093" ]
then
    printf "Device type is 35T"
    DEVICE=35T
elif [ "$IDCODE" = "0x13631093" ]
then
    printf "Device type is 100T"
    DEVICE=100T
else
    printf "Device type is unknown or invalid, can't update. Press return to exit.\n"
    read dummy
    exit 1
fi


if [ "$DEVICE" = "35T" ]
then
    FPGAIMAGE="user-35.bit"
    BSCANIMAGE="bscan_spi_xc7a35t.bit"
elif [ "$DEVICE" = "100T" ]
then
    FPGAIMAGE="user-100.bit"
    BSCANIMAGE="bscan_spi_xc7a100t.bit"
else
    printf "Device type not valid, aborting! Press return to exit.\n"
    read dummy
    exit 1
fi

# convert the firmware bin into an uploadable blob
rm -f /tmp/ufirmware.upl
rm -f /tmp/ufirmware.bin

printf "\n\nPadding firmware image...\n"
# pad the firmware out to fill out the full firmware area
# the reason is that ufirmware.bin sometimes is not divisible by 4, which will
# cause the CRC computation to fail. So this forces a padding on ufirmware.bin
# which guarantees a deterministic fill for the entire firmware length and
# thus allow CRC to succeed
cp $GIT_DIR/production-images/user-firmware.bin /tmp/ufirmware.bin
dd if=/dev/zero of=/tmp/ufirmware.bin bs=1 count=1 seek=131071
$GIT_DIR/bin/mknetv2img -f --output /tmp/ufirmware.upl /tmp/ufirmware.bin
if [ $? -ne 0 ]
then
    printf "Could not pad firmware image, check permissions on /tmp. Press return to exit.\n"
    read dummy
    exit 1
fi

printf "\n\nBurning FPGA soft-core firmware update to SPINOR...\n"
sudo openocd \
     -c 'set FIRMWARE_FILE /tmp/ufirmware.upl' \
     -c "set BSCAN_FILE $OCD_SCRIPT_DIR/$BSCANIMAGE" \
     -f $OCD_SCRIPT_DIR/cl-firmware.cfg
if [ $? -ne 0 ]
then
    printf "Trouble with JTAG interface, aborting. Check for openocd and sudo priveledges. Press return to exit.\n"
    read dummy
    exit 1
fi


printf "\n\nBurning FPGA gateware bitstream to SPINOR (~1 minute)...\n"
sudo openocd \
     -c "set FPGAIMAGE $GIT_DIR/production-images/$FPGAIMAGE" \
     -c "set BSCAN_FILE $OCD_SCRIPT_DIR/$BSCANIMAGE" \
     -f $OCD_SCRIPT_DIR/cl-spifpga.cfg
if [ $? -ne 0 ]
then
   printf "Trouble with JTAG interface, aborting. Check for openocd and sudo priveledges. Press return to exit.\n"
   read dummy
   exit 1
fi

printf "\n\nFPGA update complete. Press return to exit.\n"
read dummy

exit 0

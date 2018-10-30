# netv2mvp-scripts

A collection of scripts that are helpful for setting up and debugging
the NeTV2.

Most of these are openocd config scripts. Note that it assumes you have
a symlink to alphamax-rpi.cfg installed in ${INSTALLDIR}/interface/.

If you compiled using this configuration:

```
./configure --enable-bcm2835gpio --enable-sysfsgpio --disable-werror --prefix=/opt/openocd
```

You would need to put the symlink in this directory:

```
/opt/openocd/share/openocd/scripts/interface/
```

Significantly, you *will* need to compile your own version of openocd
to work with NeTV2. The mainline openocd has a bug in the bcm2835 driver code
that greatly limits the reliable speed of operation, and a patch has been
submitted but it looks like they aren't going to take it. Instead, take
this fork:

https://github.com/AlphamaxMedia/openocd.git

Clone it recursively and build and install it. If you use this, openocd
runs about 20x faster than if you use the mainline version.

The default NeTV2 firmware image already includes this source directory
and binary pre-installed for you.

Non-sequiter dev note: to start flterm, you want a command line like this:

```
./flterm --port /dev/ttyS0 --speed 115200 --kernel firmware.bin
```

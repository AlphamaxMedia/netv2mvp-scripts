# Magic Mirror helper scripts

netv2-status is a node module that reads the serial port and
reflects status messages emitted by the FPGA firmware to
a webserver on port 6502. It's meant to be daemonized and run via pm2.

netv2-term is a magic mirror module, by symlinking (or copying)
the netv2-term directroy into MagicMirror/modules, magic mirror
should pick up the module and render it to the screen.

For more info on MagicMirror check out https://github.com/MichMich/MagicMirror

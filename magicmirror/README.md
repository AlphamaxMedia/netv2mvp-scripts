# Magic Mirror helper scripts

netv2-status is a node module that reads the serial port and
reflects status messages emitted by the FPGA firmware to
a webserver on port 6502. It's meant to be daemonized and run via pm2.

netv2-term is an attempt at a magic mirror module. It never quite worked,
but it's an interesting curio to look at later on.

The status feed on the screen is instead done using "MMM-json-feed", with the
following entry in config/config.js:

   modules: [
...   
		{
		    module: "MMM-json-feed",
		    position: "top_left",
  		    config: {
			url: 'http://127.0.0.1:6502/',  // this comes from running "node netv2-status.js"
			updateInterval: 2000,
			title: "NeTV2 Status",
		    },
		},
...

For more info on MagicMirror check out https://github.com/MichMich/MagicMirror

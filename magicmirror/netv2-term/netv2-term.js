/* global Module */

Module.register("netv2-term", {
    defaults: {
	status: {
	    readbw: 0,
	    writebw: 0,
	    in0_ph0: 0,
	    in0_ph1: 0,
	    in0_ph2: 0,
	    in0_charsync: 000,
	    in0_sp0: 0,
	    in0_sp1: 0,
	    in0_sp2: 0,
	    in0_wer0: 0,
	    in0_wer1: 0,
	    in0_wer2: 0,
	    in0_chansync: 0,
	    in1_ph0: 0,
	    in1_ph1: 0,
	    in1_ph2: 0,
	    in1_charsync: 000,
	    in1_sp0: 0,
	    in1_sp1: 0,
	    in1_sp2: 0,
	    in1_wer0: 0,
	    in1_wer1: 0,
	    in1_wer2: 0,
	    in1_chansync: 0,
	    in0_x: 0,
	    in0_y: 0,
	    in0_pclk: 0,
	    in1_x: 0,
	    in1_y: 0,
	    in1_pclk: 0,
	    temp: 0
	},
	SerialPort : null,
	port : null,
	conString: '',
	text : "hello world", 
    },

    getDom: function() {
	//	return this.config.status.stringify()
	var wrapper = document.createElement("div");
	wrapper.innerHTML = JSON.stringify(this.config.status);
	return wrapper;
    },

    start: function() {
	var self = this;
	setInterval(function() {
	    self.updateDom();
	}, 1000);
    }
/*
    start: function() {
	this.config.SerialPort = require('serialport');
	this.config.port = new SerialPort('/dev/ttyS0', {baudRate: 115200});

	this.config.port.write('json on\n\r', function(err) {
	    if (err) {
		return console.log('Error on write: ', err.message);
	    }
	    console.log('Enable JSON status message sent to NeTV2');
	});
	
	this.config.port.on('readable', function() {
	    this.config.conString = this.config.conString + this.config.port.read().toString('utf8');
	    var match = /\r|\n/.exec(this.config.conString)
	    if(match) {
		if( this.config.conString.length > 40 ) { // ignore other responses, expect large JSON record
		    //	    console.log( 'json: ' + conString );
		    this.config.status = JSON.parse(conString);
		    console.log(this.config.status);
		}
		this.config.conString = '';
	    }
	    
	});
    } 
*/
});



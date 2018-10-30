var SerialPort = require('serialport');
var port = new SerialPort('/dev/ttyS0', {baudRate: 115200});

var http = require('http');

port.write('json on\n\r', function(err) {
    if (err) {
	return console.log('Error on write: ', err.message);
    }
    console.log('message written');
});

// Open errors will be emitted as an error event
port.on('error', function(err) {
    console.log('Error: ', err.message);
})

var conString = '';
var status;
port.on('readable', function() {
    conString = conString + port.read().toString('utf8');
    var match = /\r|\n/.exec(conString)
    if(match) {
	if( conString.length > 200 ) { // ignore other responses from terminal program, expect large JSON record
	    //	    console.log( 'json: ' + conString );
	    try {
		status = JSON.parse(conString);
	    } catch(e) {
		conString = '';
	    }
	    console.log(status);
	}
	conString = '';
    }
    
});

http.createServer(function(req,res) {
    res.write(JSON.stringify(status));
    res.end();
}).listen(6502);

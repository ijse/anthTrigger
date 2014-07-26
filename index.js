
require('coffee-script/register');

global.__config = configs = require(process.env.HOME + '/.anthTrigger.config');
global.__util = require('./lib/utils');

var server = require('./lib/server')(configs);

server.listen(configs.listen, function() {
	console.log("================================");
	console.log("= Server start at port " + configs.listen + ".");
	console.log("================================");
})


require('coffee-script/register');
var defaultConfigs = require('./config.default.js');

global.__util = require('./lib/utils');

configs = require(process.env.HOME + '/.anthTrigger.config');

configs = __util.extend(defaultConfigs, configs);

global.__config = configs
var server = require('./lib/server')(configs);

server.listen(configs.listen, function() {
	console.log("================================");
	console.log("= Server start at port " + configs.listen + ".");
	console.log("================================");
})

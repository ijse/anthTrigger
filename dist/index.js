
require('coffee-script/register')

global.__config = configs = require('./configs')
global.__util = require('./lib/utils')

var server = require('./lib/server')(configs)

server.listen(configs.listen)

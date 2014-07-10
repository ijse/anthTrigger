
require('coffee-script/register')

global.__config = configs = require('./configs')
var server = require('./lib/server')(configs)

server.listen(configs.listen)

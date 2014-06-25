
require('coffee-script/register')

configs = require('./configs')
var server = require('./lib/server')(configs)

server.listen(5678)

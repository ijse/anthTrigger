
os = require 'os'
exports.attach = (app)->

	app.get '/ping', (req, res)-> res.send('pong!')

	app.get '/whereAmI', (req, res)->
		res.json {
			ip: req.socket.localAddress
			hostname: os.hostname()
		}

	require('./users').route(app)
	require('./script').route(app)
	require('./scriptLogs').route(app)
	require('./events').route(app)

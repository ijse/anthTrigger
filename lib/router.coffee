
exports.attach = (app)->

	app.get '/ping', (req, res)-> res.send('pong!')

	app.get '/whereAmI', (req, res)->
		res.json {
			ip: req.ip
			ips: req.ips
			host: req.host
		}

	require('./users').route(app)
	require('./script').route(app)
	require('./scriptLogs').route(app)
	require('./events').route(app)
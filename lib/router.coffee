
exports.attach = (app)->

	app.get '/ping', (req, res)-> res.send('pong!')


	require('./users').route(app)
	require('./script').route(app)


os = require 'os'
Package = require '../package.json'

nonAuthList = [
	'/assets/css/bootstrap.css'
	'/components/jquery/dist/jquery.min.js'
	'/favicon.ico'
	'/page/login.html'
	'/login'
]

exports.attach = (app)->

	app.get '/ping', (req, res)-> res.send('pong!')

	app.get '/whereAmI', (req, res)->
		res.json {
			ip: req.socket.localAddress
			hostname: os.hostname()
			version: Package.version
		}

	app.get '*', (req, res, next)->
		return next() if req.session.user or nonAuthList.indexOf(req.url) isnt -1
		if req.xhr
			res.json {
				success: false
				error: 'Not login'
			}
			return
		else
			res.redirect('/page/login.html')
			return

	require('./users').route(app)
	require('./script').route(app)
	require('./scriptLogs').route(app)
	require('./events').route(app)
	require('./dashboard').route(app)
	require('./settings').route(app)

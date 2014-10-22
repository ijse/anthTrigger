
os = require 'os'
Package = require '../package.json'
https = require 'https'
compareVersion = require 'compare-version'

nonAuthList = ///
	(
		/components/(.*)$|
		/js/(.*)$|
		/css/(.*)$|
		/assets/css/bootstrap.css|
		/favicon.ico|
		/checkUpdate|
		/page/login.html|
		/login
	)
///

getVersionFromGithub = (callback)->
	options = {
		hostname: 'api.github.com',
		path: '/repos/ijse/anthTrigger/releases',
		method: 'GET',
		headers: {
			'User-Agent': 'node.js, anthTrigger'
		}
	}

	https.request options, (resp)->
		result = ''
		resp.on 'data', (data)->
			result += data
		resp.on 'end', ->
			callback(null, result)
	.on 'error', (e)->
		callback(e)
	.end()

exports.attach = (app)->

	app.get '/ping', (req, res)-> res.send('pong!')

	app.get '/whereAmI', (req, res)->
		res.json {
			ip: req.socket.localAddress
			hostname: os.hostname()
			version: Package.version
		}

	app.get '/checkUpdate', (req, res)->
		result = {}

		getVersionFromGithub (err, data)->
			try
				latestRelease = JSON.parse(data)[0]
				localVer = "v#{Package.version}"
				curVer = latestRelease.tag_name

				result.hasNew = compareVersion(curVer, localVer) > 0
				result.curRelease = latestRelease

			catch e
				result.hasNew = false

			res.json result

	app.get '*', (req, res, next)->
		return next() if req.session.user
		return next() if nonAuthList.test(req.url)
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

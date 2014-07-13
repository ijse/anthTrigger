
express = require 'express'
session = require 'express-session'
bodyParser = require 'body-parser'
logger = require 'morgan'
path = require 'path'
router = require './router'

module.exports = (configs)->

	app = express()
	app.use logger('dev')

	# session support
	app.use session({
	  resave: false, # don't save session if unmodified
	  saveUninitialized: false, # don't create session until something stored
	  secret: 'AnthTrigger session secret'
	})

	app.use(bodyParser())

	# Load routes
	router.attach(app)

	app.use express.static(__dirname + '/../public')
	app.get '*', (req, res, next)->
		res.sendfile path.join(__dirname, '../public/index.html')

	# 404
	app.use (req, res, next)->
		res.status(404)
		res.json { status: 404, url: req.url }

	# 500, When next(err)...
	app.use (err, req, res, next)->
		res.status(500)
		res.json {
			status: err.status or 500
			error: err
		}

	return app

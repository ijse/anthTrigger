
express = require 'express'
session = require 'express-session'
bodyParser = require 'body-parser'
logger = require 'morgan'

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

	return app


express = require 'express'
session = require 'express-session'
MongoStore = require('connect-mongo')(session)
bodyParser = require 'body-parser'
cookieParser = require 'cookie-parser'
logger = require 'morgan'
path = require 'path'
router = require './router'
utils = require './utils'

socketIO = require 'socket.io'
http = require 'http'

module.exports = (configs)->

	# connect mongodb
	utils.connectDB(configs.mongodb)

	app = express()

	# create socket.io service
	server = http.Server(app)
	io = socketIO(server)
	app.set 'socket', io

	app.use logger('dev')
	app.set 'configs', configs

	app.use cookieParser('anthTrigger')
	# session support
	app.use session({
	  resave: false, # don't save session if unmodified
	  saveUninitialized: false, # don't create session until something stored
	  secret: 'AnthTrigger session secret'
	  store: new MongoStore({
		  url: configs.mongodb
		  auto_reconnect: true
	  })
	  cookie: {
			maxAge: 60*60*1000 # 1 hour
	  }
	})


	app.use(bodyParser.urlencoded( { extended: true }))
	app.use(bodyParser.json())

	# Load routes
	router.attach(app)

	app.use express.static(path.join(__dirname, '../.tmp'))
	app.use express.static(path.join(__dirname, '../public'))
	app.get "*", (req, res, next)->
		res.sendfile path.join(__dirname, '../public/index.html')

	# 404
	app.use (req, res, next)->
		res.status(404)
		res.json { status: 404, url: req.url }

	# 500, When next(err)...
	# app.use (err, req, res, next)->
	# 	res.status(500)
	# 	res.json {
	# 		status: err.status or 500
	# 		error: err
	# 	}

	return server

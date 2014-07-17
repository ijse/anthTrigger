Thenjs = require 'thenjs'

mongoose = require 'mongoose'

exports.connectDB = (dburl)->
	Thenjs (cb)->
		mongoose.connect(dburl)
		db = mongoose.connection
		db.on 'error', console.error.bind(console, 'connection error:')

		db.once 'open', ()->
			cb()

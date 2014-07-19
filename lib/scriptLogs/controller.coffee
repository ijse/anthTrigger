Thenjs = require 'thenjs'
logsModel = require '../scriptLogs/logsModel'

exports.list = (crital={})->
	Thenjs (cont)->
		logsModel
		.find crital, (err, list)->
			return cont(err) if err
			cont(null, list)


exports.findById = (id)->
	Thenjs (cont)->
		logsModel
		.findById id, (err, doc)->
			cont(err, doc)
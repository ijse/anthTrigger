Thenjs = require 'thenjs'
logsModel = require '../scriptLogs/logsModel'

exports.list = (crital={})->
	Thenjs (cont)->
		logsModel
		.find crital, (err, list)->
			return cont(err) if err
			cont(null, list)

exports.listByPage = (crital, opts)->
	Thenjs (cont)->
		logsModel
		.find crital, null, opts, (err, list)->
			return cont(err) if err
			cont(null, list)
	.then (cont, list)->
		# Get total count
		logsModel.count crital, (err, count)->
			return cont(err) if err
			cont(null, list, count)

exports.count = (crital)->
	Thenjs (cont)->
		logsModel
		.count crital, (err, count)->
			return cont(err) if err
			cont(null, count)

exports.findById = (id)->
	Thenjs (cont)->
		logsModel
		.findById id, (err, doc)->
			cont(err, doc)
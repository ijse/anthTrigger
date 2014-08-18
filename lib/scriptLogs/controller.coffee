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
		.find crital, {
        _id: 1
        snapshot: 1
        startAt: 1
        endAt: 1
      }, opts, (err, list)->
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

exports.getRecentLog = (count)->
	Thenjs (cont)->
		logsModel
		.find {}, {
			_id: 1
			snapshot: 1
			runByUser: 1
			startAt: 1
			endAt: 1
		}, {
			sort: '-startAt'
			limit: count
		}, (err, list)->
			cont(null, list)

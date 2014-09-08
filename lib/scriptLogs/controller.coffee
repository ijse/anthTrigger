Thenjs = require 'thenjs'
logsModel = require '../scriptLogs/logsModel'
moment = require 'moment'

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

exports.getUsageStats = (lastDate)->

	Thenjs (cont)->

		logsModel
		.aggregate {
			$group: {
				_id: {
					year: { $year: "$startAt" }
					month: { $month: "$startAt" }
					day: { $dayOfMonth: "$startAt" }
				},
				count: { $sum: 1 }
			}
		}
		.sort({ _id: 1 })
		.exec (err, result)->
			result.map (v)->
				v.date = moment({
					year: v._id.year
					month: v._id.month-1
					day: v._id.day
				}).toDate()
				v._id = null
				delete v._id

			cont(err, result)

		return


mongoose = require 'mongoose'

schema = mongoose.Schema {
	title: {
		type: String
	}
	codes: String
	description: {
		type: String
		default: ''
	}
	createAt: {
		type: Date
		default: Date.now
	}
	updateAt: {
		type: Date
		default: Date.now
	}
	lastRunByUser: {
		type: mongoose.Schema.Types.ObjectId
		default: null
	}
	lastUpdateByUser: {
		type: mongoose.Schema.Types.ObjectId
		default: null
	}
	lastRunAt: {
		type: Date
		default: null
	}
	lastRunEnd: {
		type: Date
		default: null
	}
	status: {
		type: String
		enum: 'ready,running'.split(',')
		default: 'ready'
	}
}

model = mongoose.model 'script', schema

module.exports = model

mongoose = require 'mongoose'
autoinc = require 'mongoose-id-autoinc2'

schema = mongoose.Schema {
	scriptId: Number
	title: {
		type: String
	}
	description: {
		type: String
		default: ''
	}
	codes: String
	tags: [ String ]
	createAt: {
		type: Date
		default: Date.now
	}
	updateAt: {
		type: Date
		default: Date.now
	}
	createByUser: {
		type: mongoose.Schema.Types.ObjectId
		default: null
	}
	lastRunByUser: {
		type: mongoose.Schema.Types.ObjectId
		default: null
	}
	lastUpdateByUser: {
		type: mongoose.Schema.Types.ObjectId
		default: null
	}
	lastRunLogs: {
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
autoinc.init(mongoose.connection, 'counter', mongoose)
schema.plugin autoinc.plugin, {
	model: 'script'
	field: 'scriptId'
	start: 1
	step: 1
	once: true
}

model = mongoose.model 'script', schema

module.exports = model
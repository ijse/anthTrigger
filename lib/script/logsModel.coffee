
mongoose = require 'mongoose'

schema = mongoose.Schema {
	scriptId: {
		type: mongoose.Schema.Types.ObjectId
		default: null
	}
	pid: {
		type: Number
		default: null
	}
	runByUser: {
		type: mongoose.Schema.Types.ObjectId
		default: null
	}
	startAt: {
		type: Date
		default: Date.now
	}
	endAt: {
		type: Date
		default: Date.now
	}
	content: String
}
model = mongoose.model 'scriptLogs', schema

module.exports = model
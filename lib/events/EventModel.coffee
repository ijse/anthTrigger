
mongoose = require 'mongoose'

schema = mongoose.Schema {
	byUser: {
		type: String
		default: 'nobody'
	}
	timeAt: {
		type: Date
		default: Date.now
	}
	message: String
}
model = mongoose.model 'events', schema

module.exports = model
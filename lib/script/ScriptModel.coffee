
mongoose = require 'mongoose'

schema = mongoose.Schema {
	title: {
		type: String
	}
	codes: String
	description: String
	createAt: {
		type: Date
		default: Date.now
	}
}

model = mongoose.model 'script', schema

module.exports = model
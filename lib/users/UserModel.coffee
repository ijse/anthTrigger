
mongoose = require 'mongoose'

schema = mongoose.Schema {
	name: String
	password: String
	role: {
		type: String
		default: 'user'
	}
}

User = mongoose.model 'user', schema

module.exports = User
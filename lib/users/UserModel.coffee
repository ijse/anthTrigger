
mongoose = require 'mongoose'

schema = mongoose.Schema {
	name: {
		type: String
		unique: true
	}
	password: String
	role: {
		type: String
		default: 'user'
		enum: 'user,manager,admin'.split(',')
	}
	tags: Array
	lastLoginAt: Date
	frozen: {
		type: Boolean
		default: false
	}
}

User = mongoose.model 'user', schema

module.exports = User
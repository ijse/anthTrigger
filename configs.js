module.exports = {

	listen: process.env.VCAP_APP_PORT || process.env.PORT || 5678,

	mongodb: process.env.MONGODB || "mongodb://127.0.0.1:27017/anthTrigger",
	shellDir: __dirname + '/shells',
	dbDir: __dirname + '/database'
}

module.exports = {

	listen: process.env.VCAP_APP_PORT || process.env.PORT || 5678,

	mongodb: "mongodb://admin:123@10.127.129.88:27017/anthTrigger",
	shellDir: __dirname + '/shells',
	dbDir: __dirname + '/database'
}

module.exports = {

	listen: process.env.VCAP_APP_PORT || process.env.PORT || 5678,
	shellDir: __dirname + '/shells',
	dbDir: __dirname + '/database'
}

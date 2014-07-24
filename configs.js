module.exports = {

	listen: process.env.VCAP_APP_PORT || process.env.PORT || 5678,

	mongodb: process.env.MONGODB || "mongodb://root:sa@kahana.mongohq.com:10060/anthTrigger",
	shellDir: __dirname + '/shells',
	dbDir: __dirname + '/database',

	spawnOptions: {
		shell: 'sh',
		cwd: process.env.HOME,
		env: process.env
	}

}

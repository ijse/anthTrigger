module.exports = {
	shellDir: __dirname,
	dbDir: __dirname + "/database",
	listen: 5678,
	mongodb: "mongodb://127.0.0.1:27017/anthTrigger",
	projects: {

		'Proj1': {
			cmd: 'bash',
			shell: './shells/deploy_proj1.sh',
			when: {
				ref: ''
			}
		}
	}
}

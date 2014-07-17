module.exports = {
	shellDir: __dirname,
	dbDir: __dirname + "/database",
	listen: 5678,
	mongodb: "mongodb://admin:123@10.127.129.88:27017/anthTrigger",
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

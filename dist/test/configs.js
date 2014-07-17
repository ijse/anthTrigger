module.exports = {
	shellDir: __dirname,
	dbDir: __dirname + "/database",
	listen: 5678,
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

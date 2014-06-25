module.exports = {
	shellDir: __dirname,

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
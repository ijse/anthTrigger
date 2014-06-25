module.exports = {

	shellDir: __dirname,

	projects: {

		// Repository name
		'Proj1': {
			'cmd': 'bash',
			'shell': './deploy_proj1.sh',
			'when': {
				ref: ''
			}
		}



	}
}
module.exports = {

	shellDir: __dirname + '/shells',

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
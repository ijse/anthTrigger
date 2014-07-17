module.exports = function(grunt) {
    require('load-grunt-tasks')(grunt);
    require('time-grunt')(grunt);

    grunt.initConfig({
        yeoman: {
        	'app': '.',
            'public': 'public',
            'dist': 'dist'
        },

        express: {
            options: {
                port: 5678
            },
            dev: {
                options: {
                    script: 'index.js'
                }
            }
        },
        open: {
            server: {
                url: 'http://localhost:<%=express.options.port %>'
            }
        },

        watch: {
            coffee: {
                files: ['<%= yeoman.public %>/page/**/*.coffee'],
                tasks: ['coffee:dist']
            },
            express: {
                files: [
                    '<%= yeoman.public %>/{,*//*}*.html',
                    '{.tmp,<%= yeoman.public %>}/page/{,*//*}*.{css,less,js,coffee}',
                    'server.js',
                    'lib/{,*//*}*'
                ],
                tasks: ['express:dev'],
                options: {
                    livereload: true,
                    nospawn: true //Without this option specified express won't be reloaded
                }
            },
            less: {
                files: ['<%= yeoman.public %>/page/**/*.less'],
                tasks: ['less:test']
            }
        },

        coffee: {
            options: {
                sourceMap: true,
                sourceRoot: ''
            },
            dev: {
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.public %>/page',
                    src: '{,**/}*.coffee',
                    dest: '.tmp/page',
                    ext: '.js'
                }]
            },
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.public %>/page',
                    src: '{,**/}*.coffee',
                    dest: 'dist/public/page',
                    ext: '.js'
                }]
            }
        },
        less: {
            options: {},
            dev: {
                compress: true,
                sourceMap: false,
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.public %>/page',
                    src: '**/*.less',
                    dest: '.tmp/page',
                    ext: '.css'
                }]
            },
            dist: {
                compress: false,
                sourceMap: true,
                files: [{
                    expand: true,
                    cwd: '<%= yeoman.public %>/page',
                    src: '**/*.less',
                    dest: 'dist/public/page',
                    ext: '.css'
                }]
            }
        },

        copy: {
        	dist: {
        		files: [{
        			expand: true,
        			dot: true,
          			cwd: '<%= yeoman.public %>',
					dest: '<%= yeoman.dist %>/public',
					src: [
						'!**/*.coffee',
						'!**/*.less',
                        '**/*'
					]
        		}, {
                    expand: true,
                    dot: true,
                    cwd: '<%= yeoman.app %>',
                    dest: '<%= yeoman.dist %>',
                    src: [
                        'database/**/*',
                        'lib/**/*',
                        'test/**/*',
                        'index.js',
                        'configs.js',
                        'package.json'
                    ]
                }]
        	}
        },

        clean: {
            dist: {
                files: [{
                    dot: true,
                    src: [
                        '.tmp',
                        'dist'
                    ]
                }]
            },
            dev: {
                files: [{
                    dot: true,
                    src: [ '.tmp' ]
                }]
            }
        }
    });


	grunt.registerTask('server', [
        'clean:dev',
		'coffee:dev',
		'less:dev',
		'express:dev',
		'open',
		'watch'
	]);

	grunt.registerTask('build', [
        'clean:dist',
		'copy:dist',
		'coffee:dist',
		'less:dist'
	]);
}

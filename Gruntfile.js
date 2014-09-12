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
                port: 3333
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
                files: ['<%= yeoman.public %>/**/*.coffee'],
                tasks: ['coffee:dev']
            },
            express: {
                files: [
                    '<%= yeoman.public %>/{,*//*}*.html',
                    '{.tmp,<%= yeoman.public %>}/{,*//*}*.{css,less,js,coffee}',
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
                files: ['<%= yeoman.public %>/**/*.less'],
                tasks: ['less:dev']
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
                }, {
                    expand: true,
                    cwd: '<%= yeoman.public %>/modules',
                    src: '{,**/}*.coffee',
                    dest: '.tmp/modules',
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
                }, {
                    expand: true,
                    cwd: '<%= yeoman.public %>/modules',
                    src: '{,**/}*.coffee',
                    dest: 'dist/public/modules',
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
                        'lib/**/*',
                        'index.js',
                        'setup.js',
                        'config.default.js',
			'README.md',
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
        },

        sonarRunner: {
            analysis: {
                options: {
                    debug: true,
                    separator: '\n',
                    sonar: {
                        host: {
                            url: 'http://sonar.dev.c-launcher.com'
                        },
                        jdbc: {
                            url: 'jdbc:mysql://sonar.dev.c-launcher.com:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true',
                            username: 'sonar',
                            password: 'sonar'
                        },

                        projectKey: 'sonar:grunt-sonar-runner:0.1.0',
                        projectName: 'Grunt Sonar Runner',
                        projectVersion: '0.10',
                        sources: ['public/modules', 'public/page', 'lib'].join(','),
                        language: 'js',
                        sourceEncoding: 'UTF-8'
                    }
                }
            }
        }
    });

    grunt.registerTask('express-keepalive', 'Keep grunt running', function() {
        this.async();
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

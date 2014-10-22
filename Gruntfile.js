module.exports = function(grunt) {
	grunt.initConfig({
		jshint: {
			all: ["assets/src/js/**/*.js"]	
		},
		
		uglify: {
			build: {
				files: [{
					cwd: "assets/src/js",
					src: "**/*.js",
					dest: "assets/dist/js/",
					expand: true 
				}]
			}
		},
		
		cssmin: {
			build: {
				files: {
					"assets/dist/css/main.min.css": "assets/src/css/main.css"	
				}
			}
		},

		imagemin: {
			dist: {
				options: {
					optimizationLevel: 5
				},
				files: [{
					cwd: "assets/src/img",
					src: ["**/*.{png,jpg,gif}"],
					dest: "assets/dist/img",
					expand: true
				}]
			}
		},

		handlebars: {
			options: {
				processName: function(filePath) {
					return filePath.replace(/^assets\/src\/templates\//,"").replace(/\.hbs$/,"");
				}
			}, 			
			all: {
				files: {
					"assets/dist/templates/principal.js": ["assets/src/templates/principal/*.hbs"]
				}
			}
		},
		
		watch: {
			css: {
				files: ["assets/src/css/**/*.css"],
				tasks: ["newer:cssmin"]
			},
			js: {
				files: ["assets/src/js/**/*.js"],
				tasks: ["newer:jshint", "newer:uglify"]
			},
			img: {
				files: ["assets/src/img/**/*.{png,jpg,gif}"],
				tasks: ["newer:imagemin"]
			},
			hbs: {
				files: ["assets/src/templates/**/*.hbs"],
				tasks: ["newer:handlebars"]
			}
		},
		
		concurrent: {
			options: {
				logConcurrentOutput: true	
			},
			tasks: ["watch"]
		}
	});
	
	grunt.loadNpmTasks("grunt-contrib-jshint");
	grunt.loadNpmTasks("grunt-contrib-uglify");
	grunt.loadNpmTasks("grunt-contrib-cssmin");
	grunt.loadNpmTasks("grunt-contrib-watch");
	grunt.loadNpmTasks("grunt-concurrent");
	grunt.loadNpmTasks("grunt-newer");
	grunt.loadNpmTasks("grunt-notify");
	grunt.loadNpmTasks("grunt-contrib-imagemin");
	grunt.loadNpmTasks("grunt-contrib-handlebars");
	
	grunt.registerTask("default",["jshint","uglify","imagemin","cssmin","handlebars","concurrent"]);
};
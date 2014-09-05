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
		
		watch: {
			css: {
				files: ["assets/src/css/**/*.css"],
				tasks: ["newer:cssmin"]
			},
			js: {
				files: ["assets/src/js/**/*.js"],
				tasks: ["newer:jshint", "newer:uglify"]
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
	
	grunt.registerTask("default",["jshint","uglify","cssmin","concurrent"]);
};
module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee :{
      compile:{},
        glob_to_multiple: {
          expand: true,
          //cwd: ['src/'],
          src: ['src/*.coffee','spec/*.coffee'],
          dest: 'js/',
          ext: '.js'
        }
    },

    jasmine_node: {
      specNameMatcher: "_spec", // load only specs containing specNameMatcher
      projectRoot: "js",
      requirejs: false,
      forceExit: true,
      jUnit: {
        report: false,
        savePath : "./build/reports/jasmine/",
        useDotNotation: true,
        consolidate: true
      }
    },

    watch: {
      files: ['src/*.coffee','spec/*'],
      tasks: ['coffee','jasmine_node']
    }
  });

  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-jasmine-node');
  
  grunt.registerTask('default', ['coffee','watch']);
  grunt.registerTask('test', ['coffee','jasmine_node']);
};
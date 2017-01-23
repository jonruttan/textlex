module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      glob_to_multiple:
        expand: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'lib'
        ext: '.js'

    coffeelint:
      options:
        no_empty_param_list:
          level: 'error'
        max_line_length:
          level: 'ignore'

      gruntfile: ['Gruntfile.coffee']
      src: ['src/*.coffee']
      test: ['spec/*.coffee']

    shell:
      test:
        command: 'node node_modules/.bin/jasmine-focused --captureExceptions --coffee spec'
        options:
          stdout: true
          stderr: true
          failOnError: true

    watch:
      scripts:
        files: ['src/*.coffee', 'spec/*.coffee'],
        tasks: ['test'],
        options:
          spawn: false

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadTasks 'tasks'

  grunt.registerTask 'clean', ->
    grunt.file.delete 'lib' if grunt.file.exists 'lib'
    grunt.file.delete 'gen' if grunt.file.exists 'gen'

  grunt.registerTask 'lint', ['coffeelint']
  grunt.registerTask 'build', ['coffeelint', 'coffee']
  grunt.registerTask 'default', ['build']
  grunt.registerTask 'test', ['build', 'lint', 'shell:test']
  grunt.registerTask 'prepublish', ['clean', 'build-grammars', 'test']

module.exports = (grunt) ->

  grunt.initConfig

    coffee        :
      options     :
        bare      : yes
      src         :
        files     : [
          expand  : yes
          cwd     : 'src'
          src     : [ '**/*.coffee' ]
          dest    : 'build/js/'
          ext     : '.js'
        ]
      tests       :
        files     : [
          expand  : yes
          cwd     : 'tests'
          src     : [ '**/*.coffee' ]
          dest    : 'build/tests/'
          ext     : '.js'
        ]

    watch                :
      options            :
        livereload       : yes
        interrupt        : yes
      src                :
        files            : [ 'src/**/*.coffee' ]
        tasks            : [ 'coffee:src' ]
      tests              :
        files            : [ 'tests/**/*.coffee' ]
        tasks            : [ 'coffee:tests' ]


  grunt.loadNpmTasks 'grunt-npm'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'


  grunt.registerTask 'default', 'Default task', ->
    grunt.task.run [
      'coffee'
      'watch'
    ]

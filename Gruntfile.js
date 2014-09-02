/*jshint camelcase: false*/

module.exports = function (grunt) {
  'use strict';

  // load all grunt tasks
  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  // configurable paths
  var config = {
    app: 'app',
    build: 'build',
    dist: 'dist',
    tmp: 'tmp',
    resources: 'resources'
  };

  grunt.initConfig({
  config: config,
  clean: {
    dist: {
    files: [{
      dot: true,
      src: [
      '<%= config.dist %>/*',
      '<%= config.tmp %>/*',
      '<%= config.build %>/*'
      ]
    }]
    }
  },
  jshint: {
    options: {
    jshintrc: '.jshintrc'
    },
    files: '<%= config.build %>/js/*.js'
  },
  copy: {
    copyAssets: {
      files: [{
        expand: true,
        cwd: '<%= config.app %>',
        dest: '<%= config.build %>',
        src: ['**', '!**/*.less', '!**/*.coffee']
      }]
    }
  },
  watch: {
    options: {
    livereload: true
    },
    coffee: {
      files: '<%= config.app %>/js/**/*.coffee',
      tasks: ["coffee:compile"]
    },
    less: {
      files: '<%= config.app %>/css/**/*.less',
      tasks: ["less"]
    },
    html: {
      files:  '<%= config.app %>/**/*.html',
      tasks: ["copy:copyAssets"]
    },
    images: {
      files:  '<%= config.app %>/img/*',
      tasks: ["copy:copyAssets"]
    }
  },
  coffee: {
    compile: {
      files: [{
        expand: true,
        cwd: '<%= config.app %>/js',
        src: ['**/*.coffee'],
        dest: '<%= config.build %>/js',
        ext: ".js"
      }]
    }
  },
  less: {
    sources : {
      files: [{
      expand: true,
      cwd: '<%= config.app %>/css',
      src: ['**/*.less'],
      dest: '<%= config.build %>/css',
      ext: ".css"
      }]
    }
  },
  connect: {
    server: {
    options: {
      port: 8000,
      livereload: true,
      base: '<%= config.build %>'
    }
    }
  },
  shell: {
    bower: {
      command: "bower install"
    },
    patch: {
      command: './setup'
    }
  },
  nodewebkit: {
    options: {
        version: '0.8.6', // make sure to change ./setup when touching this
        macIcns: '<%= config.app %>/img/icon/osx.icns', //OSX only
        winIco: '<%= config.app %>/img/icon/windows.ico', //Windows only
        cacheDir: '<%= config.dist %>/cache',
        buildDir: '<%= config.dist %>/releases',
        platforms: [] // OS will be set by 'dist' task
    },
    src: ['<%= config.build %>/**/*']
  },
  });

  grunt.registerTask('dist-linux', [
  'jshint',
  'clean:dist',
  'build',
  ], function() {
    grunt.config.set('nodewebkit.options.platforms', ['linux32', 'linux64'])
    grunt.task.run("nodewebkit")
  });

  grunt.registerTask('dist-win', [
  'clean:dist',
  'build',
  ], function() {
    grunt.config.set("nodewebkit.options.platforms", ['win'])
    grunt.task.run("nodewebkit")
  });

  grunt.registerTask('dist-mac', [
  'clean:dist',
  'build',
  'shell:patch'
  ], function() {
    grunt.config.set("nodewebkit.options.platforms", ['osx'])
    grunt.task.run("nodewebkit")
  }
  );

  grunt.registerTask('lint', [
  'jshint'
  ]);

  grunt.registerTask('dmg', 'Create dmg from previously created app folder in dist.', function () {
    var done = this.async();
    var createDmgCommand = 'resources/mac/package.sh "localcast"';
    require('child_process').exec(createDmgCommand, function (error, stdout, stderr) {
      var result = true;
      if (stdout) {
      grunt.log.write(stdout);
      }
      if (stderr) {
      grunt.log.write(stderr);
      }
      if (error !== null) {
      grunt.log.error(error);
      result = false;
      }
      done(result);
    });
  });

  grunt.registerTask("default", ["build", "connect", "watch"])
  grunt.registerTask("build", ["shell:bower", "coffee:compile", "less:sources", "copy:copyAssets"])

}

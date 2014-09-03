/*jshint camelcase: false*/

module.exports = function (grunt) {
  'use strict';

  // load all grunt tasks
  var matchdep = require('matchdep')
  var wrench = require('wrench');
  var _ = require('lodash');
  var fs = require('fs');
  var path = require('path');

  matchdep.filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  // configurable paths
  var config = {
    app: 'app',
    build: 'build',
    dist: 'dist'
  };

  grunt.initConfig({
    config: config,
    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
          '<%= config.build %>/*',
          '<%= config.dist %>/releases/*'
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
      },
      modules: {
        files: [{
          expand: true,
          cwd: 'node_modules',
          dest: '<%= config.build %>',
          src: ['**/*']
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
    packageNodeWebkit: {
      options: {
        dest: '<%= config.build %>'
      }
    }
  });

  grunt.registerTask('dist-linux', function() {
    grunt.config.set('nodewebkit.options.platforms', ['linux32', 'linux64'])
    grunt.task.run("packageNodeWebkit")
  });

  grunt.registerTask('dist-win', function() {
    grunt.config.set("nodewebkit.options.platforms", ['win'])
    grunt.task.run("packageNodeWebkit")
  });

  grunt.registerTask('dist-mac', function() {
    grunt.config.set("nodewebkit.options.platforms", ['osx'])
    grunt.task.run("packageNodeWebkit")
  });

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

  grunt.registerTask("packageNodeWebkit", "Package project as standalone nodewebkit app", function(){
    var options = this.options();

    // Build coffeescript / less
    grunt.task.run("clean:dist");
    grunt.task.run("build");

    // Copy node modlues app to compiled JS
    wrench.mkdirSyncRecursive(path.join(options.dest, 'node_modules'));

    var devDependancies = matchdep.filterDev('*');
    var modulesDirectories = fs.readdirSync("node_modules");
    _.difference(modulesDirectories, devDependancies).forEach(
      function(directory) {
        wrench.copyDirSyncRecursive(path.join('node_modules', directory), path.join(options.dest, 'node_modules', directory));
      }
    )

    // Package app for specified platforms
    grunt.task.run("nodewebkit");

    // Remove copy of node_modules directory
    // TODO Wait for the above "nodewebkit" task to finish before deleting the dir
    //wrench.rmdirSyncRecursive(path.join(options.dest, 'node_modules'));

  });

}

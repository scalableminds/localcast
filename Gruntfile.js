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
    appLinux: {
    files: [{
      expand: true,
      cwd: '<%= config.build %>',
      dest: '<%= config.dist %>/app.nw',
      src: '**'
    }]
    },
    appMacos: {
    files: [{
      expand: true,
      cwd: '<%= config.build %>',
      dest: '<%= config.dist %>/node-webkit.app/Contents/Resources/app.nw',
      src: '**'
    }, {
      expand: true,
      cwd: '<%= config.resources %>/mac/',
      dest: '<%= config.dist %>/node-webkit.app/Contents/',
      filter: 'isFile',
      src: '*.plist'
    }, {
      expand: true,
      cwd: '<%= config.resources %>/mac/',
      dest: '<%= config.dist %>/node-webkit.app/Contents/Resources/',
      filter: 'isFile',
      src: '*.icns'
    }]
    },
    webkit: {
    files: [{
      expand: true,
      cwd: '<%=config.resources %>/node-webkit/MacOS',
      dest: '<%= config.dist %>/',
      src: '**'
    }]
    },
    copyWinToTmp: {
    files: [{
      expand: true,
      cwd: '<%= config.resources %>/node-webkit/Windows/',
      dest: '<%= config.tmp %>/',
      src: '**'
    }]
    },
    copyAssets: {
    files: [{
      expand: true,
      cwd: '<%= config.app %>',
      dest: '<%= config.build %>',
      src: ['**', '!**/*.less', '!**/*.coffee']
    }]
    }
  },
  compress: {
    appToTmp: {
    options: {
      archive: '<%= config.tmp %>/app.zip'
    },
    files: [{
      expand: true,
      cwd: '<%= config.app %>',
      src: ['**']
    }]
    },
    finalWindowsApp: {
    options: {
      archive: '<%= config.dist %>/localcast.zip'
    },
    files: [{
      expand: true,
      cwd: '<%= config.tmp %>',
      src: ['**']
    }]
    }
  },
  rename: {
    app: {
    files: [{
      src: '<%= config.dist %>/node-webkit.app',
      dest: '<%= config.dist %>/localcast.app'
    }]
    },
    zipToApp: {
    files: [{
      src: '<%= config.tmp %>/app.zip',
      dest: '<%= config.tmp %>/app.nw'
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
  }
  });

  grunt.registerTask('chmod', 'Add lost Permissions.', function () {
  var fs = require('fs');
  fs.chmodSync('dist/localcast.app/Contents/Frameworks/node-webkit Helper EH.app/Contents/MacOS/node-webkit Helper EH', '555');
  fs.chmodSync('dist/localcast.app/Contents/Frameworks/node-webkit Helper NP.app/Contents/MacOS/node-webkit Helper NP', '555');
  fs.chmodSync('dist/localcast.app/Contents/Frameworks/node-webkit Helper.app/Contents/MacOS/node-webkit Helper', '555');
  fs.chmodSync('dist/localcast.app/Contents/MacOS/node-webkit', '555');
  });

  grunt.registerTask('createLinuxApp', 'Create linux distribution.', function () {
  var done = this.async();
  var childProcess = require('child_process');
  var exec = childProcess.exec;
  exec('mkdir -p ./dist; cp resources/node-webkit/Linux64/nw.pak dist/ && cp resources/node-webkit/Linux64/nw dist/node-webkit', function (error, stdout, stderr) {
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

  grunt.registerTask('createWindowsApp', 'Create windows distribution.', function () {
  var done = this.async();
  var childProcess = require('child_process');
  var exec = childProcess.exec;
  exec('copy /b tmp\\nw.exe+tmp\\app.nw tmp\\localcast.exe && del tmp\\app.nw tmp\\nw.exe', function (error, stdout, stderr) {
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

  grunt.registerTask('setVersion', 'Set version to all needed files', function (version) {
  var config = grunt.config.get(['config']);
  var appPath = config.app;
  var resourcesPath = config.resources;
  var mainPackageJSON = grunt.file.readJSON('package.json');
  var appPackageJSON = grunt.file.readJSON(appPath + '/package.json');
  var infoPlistTmp = grunt.file.read(resourcesPath + '/mac/Info.plist.tmp', {
    encoding: 'UTF8'
  });
  var infoPlist = grunt.template.process(infoPlistTmp, {
    data: {
    version: version
    }
  });
  mainPackageJSON.version = version;
  appPackageJSON.version = version;
  grunt.file.write('package.json', JSON.stringify(mainPackageJSON, null, 2), {
    encoding: 'UTF8'
  });
  grunt.file.write(appPath + '/package.json', JSON.stringify(appPackageJSON, null, 2), {
    encoding: 'UTF8'
  });
  grunt.file.write(resourcesPath + '/mac/Info.plist', infoPlist, {
    encoding: 'UTF8'
  });
  });

  grunt.registerTask('dist-linux', [
  'jshint',
  'clean:dist',
  'build',
  'copy:appLinux',
  'createLinuxApp'
  ]);

  grunt.registerTask('dist-win', [
  'jshint',
  'clean:dist',
  'build',
  'copy:copyWinToTmp',
  'compress:appToTmp',
  'rename:zipToApp',
  'createWindowsApp',
  'compress:finalWindowsApp'
  ]);

  grunt.registerTask('dist-mac', [
  'clean:dist',
  'build',
  'copy:webkit',
  'copy:appMacos',
  'rename:app',
  'chmod'
  ]);

  grunt.registerTask('check', [
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

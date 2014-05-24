gulp = require 'gulp'
path = require 'path'

# Gulp Plugins
clean         = require 'gulp-clean'
bowerFiles    = require 'gulp-bower-files'
coffee        = require 'gulp-coffee'
concat        = require 'gulp-concat'
gutil         = require 'gulp-util'
jade          = require 'gulp-jade'
less          = require 'gulp-less'
templateCache = require 'gulp-angular-templatecache'
uglify        = require 'gulp-uglify'
filesize      = require 'gulp-filesize'
filter        = require 'gulp-filter'

parameters    = require '../config/parameters.coffee'

# Build tasks
gulp.task 'build', ['copy', 'compile']
gulp.task 'build-production', ['build', 'minify']

# Utility tasks
gulp.task 'clean', ->
  gulp.src parameters.web_path, read: false
  .pipe clean()
  .on 'error', gutil.log

gulp.task 'copy', ['assets', 'vendors']

gulp.task 'assets', ['clean'], ->
  gulp.src parameters.assets_path + '/**'
  .pipe gulp.dest parameters.web_path
  .on 'error', gutil.log

# JS vendors will be read from bower.json order and concatenate into [web_path]/js/[vendor_main_file]
gulp.task 'vendors', ['clean'], ->
  bowerFiles()
  .pipe filter '**/*.js'
  .pipe concat parameters.vendor_main_file
  .pipe gulp.dest parameters.web_path + '/js'
  .pipe filesize()
  .on 'error', gutil.log

# Compilation tasks
gulp.task 'compile', ['copy', 'coffee', 'templates', 'jade', 'less']

gulp.task 'coffee', ['clean'], ->
  gulp.src parameters.app_path + '/**/*.coffee'
  .pipe coffee bare: true
  .pipe concat parameters.app_main_file
  .pipe gulp.dest parameters.web_path + '/js'
  .pipe filesize()
  .on "error", gutil.log

gulp.task 'jade', ['clean'], ->
  gulp.src parameters.app_path + '/**/*.jade'
  .pipe jade pretty: true
  .pipe gulp.dest parameters.web_path
  .pipe filesize()
  .on 'error', gutil.log

gulp.task 'templates', ['clean'], ->
  version = require('../package.json').version

  gulp.src parameters.app_path + '/*/**/*.jade'
  .pipe jade doctype: 'html'
  .pipe templateCache
    filename: parameters.templates_file
    module: parameters.templates_module
    standalone: true
  .pipe gulp.dest parameters.web_path + '/js'
  .pipe filesize()
  .on 'error', gutil.log

gulp.task 'less', ['clean'], ->
  css = gulp.src parameters.less_main_file
  .pipe less paths: [ path.join(__dirname) ]
  .pipe gulp.dest parameters.web_path + '/css'
  .pipe filesize()
  .on 'error', gutil.log

gulp.task 'minify', ['coffee', 'templates'], ->
  gulp.src parameters.web_path + '/**/*.js'
  .pipe uglify()
  .pipe gulp.dest parameters.web_path
  .pipe filesize()
  .on "error", gutil.log

gulp.task 'watch', ['build'], ->
  gulp.watch parameters.app_path + '/**/*.coffee', ['compile']
  gulp.watch parameters.app_path + '/*.jade', ['compile']
  gulp.watch parameters.app_path + '/*/**/*.jade', ['compile']
  gulp.watch parameters.assets_path, ['compile']
  gulp.watch parameters.less_main_file, ['compile']
  gulp.watch 'bower_components', ['compile']

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
serve         = require 'gulp-serve'

parameters    = require '../config/parameters.coffee'

# Build tasks
gulp.task 'build', ['copy', 'compile']

# Utility tasks
gulp.task 'clean', ->
  gulp.src parameters.web_path, read: false
  .pipe clean()
  .on 'error', gutil.log

gulp.task 'copy', ['assets', 'vendors']

gulp.task 'assets', [], ->
  gulp.src parameters.assets_path + '/**'
  .pipe gulp.dest parameters.web_path
  .on 'error', gutil.log

# JS vendors will be read from bower.json order and concatenate into [web_path]/js/[vendor_main_file]
gulp.task 'vendors', [], ->
  bowerFiles()
  .pipe filter '**/*.js'
  .pipe concat parameters.vendor_main_file
  .pipe gulp.dest parameters.web_path + '/js'
  .pipe filesize()
  .on 'error', gutil.log

# Compilation tasks
gulp.task 'compile', ['copy', 'coffee', 'jade', 'less']

gulp.task 'coffee', [], ->
  gulp.src parameters.app_path + '/**/*.coffee'
  .pipe coffee bare: true
  .pipe concat parameters.app_main_file
  .pipe gulp.dest parameters.web_path + '/js'
  .pipe filesize()
  .on "error", gutil.log

gulp.task 'jade', [], ->
  gulp.src parameters.app_path + '/**/*.jade'
  .pipe jade pretty: true
  .pipe gulp.dest parameters.web_path
  .pipe filesize()
  .on 'error', gutil.log

gulp.task 'less', [], ->
  gulp.src parameters.less_main_file
  .pipe less paths: [ path.join(__dirname) ]
  .pipe gulp.dest parameters.web_path + '/css'
  .pipe filesize()
  .on 'error', gutil.log

gulp.task 'watch', ['build'], ->
  gulp.watch parameters.app_path + '/**/*.coffee', ['compile']
  gulp.watch parameters.app_path + '/**/*.jade', ['compile']
  gulp.watch parameters.assets_path, ['compile']
  gulp.watch parameters.app_path + '/**/*.less', ['compile']
  gulp.watch 'bower_components', ['compile']

  serve(parameters.web_path)()

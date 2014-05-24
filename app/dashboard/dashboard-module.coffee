angular.module 'metrix.dashboard', [
  'ng'
  'ngRoute'
]

.controller 'dashboardController', () ->

  return

.directive 'metrixProjectsBubbles', ->
  restrict: 'AE'
  link:
    console.log "directive called"
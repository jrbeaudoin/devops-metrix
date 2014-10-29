angular
.module('devops-metrix', [
  'ng'
  'ngRoute'
  'metrix.dashboard'
  'metrix.help'
  ])
.config([
  '$routeProvider'
  '$httpProvider'
  '$compileProvider'
  ($routeProvider, $httpProvider, $compileProvider) ->
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(mailto|tel|http|https):/)

    $routeProvider.otherwise
      redirectTo: '/dashboard'

    $httpProvider.defaults.useXDomain = true

    delete $httpProvider.defaults.headers.common['X-Requested-With']
])

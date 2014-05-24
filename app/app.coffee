angular
  .module('devops-metrix', [
    'ng'
    'ngRoute'

    'metrix.dashboard'
  ])
  .config([
    '$routeProvider'
    '$httpProvider'
    '$compileProvider'
    ($routeProvider, $httpProvider, $compileProvider) ->
      $compileProvider.aHrefSanitizationWhitelist(/^\s*(mailto|tel|http|https):/)

      $routeProvider.otherwise
        redirectTo: '/dashboard'

      delete $httpProvider.defaults.headers.common['X-Requested-With']
  ])

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
    '$translateProvider'
    ($routeProvider, $httpProvider, $compileProvider, $translateProvider) ->
      $compileProvider.aHrefSanitizationWhitelist(/^\s*(mailto|tel|http|https):/)

      $routeProvider.otherwise
        redirectTo: '/dashboard'

      delete $httpProvider.defaults.headers.common['X-Requested-With']
  ])

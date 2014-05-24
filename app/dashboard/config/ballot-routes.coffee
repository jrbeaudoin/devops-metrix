angular.module('metrix.dashboard')
.config [
  '$routeProvider'
  ($routeProvider) ->
    $routeProvider
    .when '/dashboard',
      templateUrl: 'dashboard/view/dashboard-view.html'
  ]

angular.module('metrix.dashboard')
.config [
  '$routeProvider'
  ($routeProvider) ->
    $routeProvider
    .when '/dashboard',
      controller: 'dashboardController'
      templateUrl: 'dashboard/view/dashboard-view.html'
  ]

angular.module('metrix.project')
.config [
  '$routeProvider'
  ($routeProvider) ->
    $routeProvider
    .when '/project/:name',
      controller: 'projectController'
      templateUrl: 'project/view/project-view.html'
  ]

angular.module('metrix.project')
.controller 'projectController', ($scope, $routeParams, $rootScope) ->
  console.log $routeParams.name
  foundProject = $rootScope.projects.filter((d) ->
    return d.name == $routeParams.name
  )
  if foundProject
    $scope.project = foundProject[0]
  return
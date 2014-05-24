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

    delete $httpProvider.defaults.headers.common['X-Requested-With']
])

.run( (dataGenerator) ->
  dataGenerator()
)

.factory 'dataGenerator', ($interval, $rootScope) ->
  return ->
    rnd_snd = ->
      return (Math.random()*2-1)+(Math.random()*2-1)+(Math.random()*2-1)

    randomInt = (min, max) ->
      parseInt(Math.random() * (max - min) + min)

    randomGauss = (mean, stdev) ->
      return Math.round(rnd_snd()*stdev+mean)

    $rootScope.projects = []
    projects = $rootScope.projects

    createData = ->
      for i in [0..10]
        projects.push
          "name": "projet " + i
          "contributors": randomGauss(8, 3)
          "commits": randomInt(200, 10000)
          "deployedOn": new Date()
          "ciStatus": not (i % 4 == 0)

    createData()

    updateData = ->
      for project in projects
        project.commits += 1 if Math.random() > 0.99
        project.deployedOn = new Date() if Math.random() > 0.995
        project.ciStatus = (Math.random() > 0.5) if Math.random() > 0.998

    $interval ->
      updateData()
    , 100

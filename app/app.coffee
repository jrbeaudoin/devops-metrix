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
      for i in [0..100]
        projects.push
          "name": "projet " + i
          "contributors": randomGauss(8, 3)
          "commits": randomInt(200, 10000)

    createData()

    updateData = ->
      for project in projects
        project.commits += Math.round(Math.random())

    $interval ->
      console.log "coucou"
      updateData()
    , 1000

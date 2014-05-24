angular
.module('devops-metrix', [
  'ng'
  'ngRoute'
  'metrix.dashboard'
  'metrix.project'
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

.factory 'dataGenerator', ($interval, $rootScope, randomNames) ->
  return ->
    rnd_snd = ->
      return (Math.random()*2-1)+(Math.random()*2-1)+(Math.random()*2-1)

    randomInt = (min, max) ->
      parseInt(Math.random() * (max - min) + min)

    randomGauss = (mean, stdev) ->
      return rnd_snd()*stdev+mean

    randomGaussInt = (mean, stdev) ->
      return Math.round randomGauss mean, stdev

    $rootScope.projects = []
    projects = $rootScope.projects

    computeScore = (project) ->
      score = 0

      timeSinceLastDeployed = new Date() - project.deployedOn
      weekInSeconds = 1000 * 5 #* 60 * 24 * 7
      switch
        when timeSinceLastDeployed < weekInSeconds
          score = score + 5
        when timeSinceLastDeployed < 2 * weekInSeconds
          score = score + 4
        when timeSinceLastDeployed < 3 * weekInSeconds
          score = score + 3
        when timeSinceLastDeployed < 4 *weekInSeconds
          score = score + 2
        when timeSinceLastDeployed < 6 * 4 *weekInSeconds
          score = score + 1

      score = score + 2 if project.ci
      score = score + 1 if project.ci and project.ciStatus

      switch
        when project.coverage > 2 / 3
          score = score + 2
        when project.coverage > 1 / 3
          score = score + 1

      score

    createData = ->
      for i in [0..30]
        projects.push
          "id": i
          "name": randomNames[i]
          "contributors": randomGaussInt 8, 3
          "commits": randomInt 200, 10000
          "deployedOn": new Date()
          "ci": ( Math.random() > 0.1 )
          "ciStatus": not (i % 4 == 0)
          "coverage": Math.min Math.max(0, randomGauss 0.5, 0.4), 1
          "online": true
      for project in projects
        project.score = computeScore project

    createData()

    updateData = ->
      for project in projects
        project.updated = false
        if Math.random() > 0.99
          project.commits += 1
          project.ciStatus = (Math.random() > 0.5) if Math.random() > 0.7
          project.coverage = Math.min Math.max(0, project.coverage + randomGauss 0, 0.05), 1
          project.updated = true
        if Math.random() > 0.995
          project.deployedOn = new Date()
          project.updated = true
        if project.updated
          if Math.random() > 0.4 and !project.online
            project.online = true
          if Math.random() > 0.93 and project.online
            project.online = false
        project.score = computeScore project

    $interval ->
      updateData()
    , 100

.constant 'randomNames', [
  "Venice"
  "Marjory"
  "Jeannine"
  "Anjanette"
  "Sharice"
  "Charlette"
  "Sanora"
  "Michaela"
  "Adrienne"
  "Lorie"
  "Arnette"
  "Hien"
  "Sima"
  "Drema"
  "Shakita"
  "Amie"
  "Josephine"
  "Christiana"
  "Cecil"
  "Simonne"
  "Brinda"
  "Jaime"
  "Elenore"
  "Larita"
  "Robert"
  "Nichelle"
  "Merrill"
  "Kerrie"
  "Milagros"
  "Shawanna"
  "Reginia"
  "Linette"
  "Reda"
  "Thaddeus"
  "Silas"
  "Edris"
  "Belen"
  "Valorie"
  "Artie"
  "Mariela"
  "Alonzo"
  "Laurice"
  "Lyndia"
  "Emilie"
  "Vada"
  "Pearlene"
  "Maura"
  "Love"
  "Lanita"
  "Kasha"
]

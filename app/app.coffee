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
      return Math.round(rnd_snd()*stdev+mean)

    $rootScope.projects = []
    projects = $rootScope.projects

    createData = ->
      for i in [0..10]
        projects.push
          "id": i
          "name": randomNames[i]
          "contributors": randomGauss(8, 3)
          "commits": randomInt(200, 10000)
          "deployedOn": new Date()
          "ciStatus": not (i % 4 == 0)
          "coverage": Math.random()

    createData()

    updateData = ->
      for project in projects
        project.updated = false
        if Math.random() > 0.99
          project.commits += 1
          project.updated = true
        if Math.random() > 0.995
          project.deployedOn = new Date()
          project.updated = true
        if Math.random() > 0.998
          project.ciStatus = (Math.random() > 0.5)

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

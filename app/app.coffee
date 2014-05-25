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
        when timeSinceLastDeployed < 4 * weekInSeconds
          score = score + 2
        when timeSinceLastDeployed < 6 * 4 * weekInSeconds
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
      visits = [
        {"date": "1-May-14", "value": 582.13},
        {"date": "30-Apr-14", "value": 583.98},
        {"date": "27-Apr-14", "value": 603.00},
        {"date": "26-Apr-14", "value": 607.70},
        {"date": "25-Apr-14", "value": 610.00},
        {"date": "24-Apr-14", "value": 560.28},
        {"date": "23-Apr-14", "value": 571.70},
        {"date": "20-Apr-14", "value": 572.98},
        {"date": "19-Apr-14", "value": 587.44},
        {"date": "18-Apr-14", "value": 608.34},
        {"date": "17-Apr-14", "value": 609.70},
        {"date": "16-Apr-14", "value": 580.13},
        {"date": "13-Apr-14", "value": 605.23},
        {"date": "12-Apr-14", "value": 622.77},
        {"date": "11-Apr-14", "value": 626.20},
        {"date": "10-Apr-14", "value": 628.44},
        {"date": "9-Apr-14", "value": 636.23},
        {"date": "5-Apr-14", "value": 633.68},
        {"date": "4-Apr-14", "value": 624.31},
        {"date": "3-Apr-14", "value": 629.32},
        {"date": "2-Apr-14", "value": 618.63},
        {"date": "30-Mar-14", "value": 599.55},
        {"date": "29-Mar-14", "value": 609.86},
        {"date": "28-Mar-14", "value": 617.62},
        {"date": "27-Mar-14", "value": 614.48},
        {"date": "26-Mar-14", "value": 606.98},
        {"date": "23-Mar-14", "value": 596.05},
        {"date": "22-Mar-14", "value": 599.34},
        {"date": "21-Mar-14", "value": 602.50},
      ]
      errors = [
        {"date": "1-May-14", "value": .13},
        {"date": "30-Apr-14", "value": .98},
        {"date": "27-Apr-14", "value": .00},
        {"date": "26-Apr-14", "value": .70},
        {"date": "25-Apr-14", "value": .00},
        {"date": "24-Apr-14", "value": .28},
        {"date": "23-Apr-14", "value": .70},
        {"date": "20-Apr-14", "value": .98},
        {"date": "19-Apr-14", "value": .44},
        {"date": "18-Apr-14", "value": .34},
        {"date": "17-Apr-14", "value": 1.70},
        {"date": "16-Apr-14", "value": 3.13},
        {"date": "13-Apr-14", "value": 4.23},
        {"date": "12-Apr-14", "value": .77},
        {"date": "11-Apr-14", "value": .20},
        {"date": "10-Apr-14", "value": .44},
        {"date": "9-Apr-14", "value": .23},
        {"date": "5-Apr-14", "value": .68},
        {"date": "4-Apr-14", "value": .31},
        {"date": "3-Apr-14", "value": .32},
        {"date": "2-Apr-14", "value": .63},
        {"date": "30-Mar-14", "value": .55},
        {"date": "29-Mar-14", "value": .86},
        {"date": "28-Mar-14", "value": .62},
        {"date": "27-Mar-14", "value": .48},
        {"date": "26-Mar-14", "value": .98},
        {"date": "23-Mar-14", "value": .05},
        {"date": "22-Mar-14", "value": .34},
        {"date": "21-Mar-14", "value": .50},
      ]
      for i in [0..10]
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
          "visits": visits
          "errors": errors
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

angular.module('metrix.dashboard')

.factory 'ProjectDataRetriever',
  ($rootScope, $interval, RandomDataGenerator, Score, DataProvider) ->
    $rootScope.projects = []

    # Generate random projects
    $rootScope.projects = $rootScope.projects.concat RandomDataGenerator.createProjects()
    
    # Add some real projects
    gulpParams =
      displayName: 'Gulp'
      entity: 'gulpjs'
      repository: 'gulp'
      coverage: 1

    $rootScope.projects.push DataProvider.getDataForProject gulpParams

    expressParams =
      displayName: 'Express'
      entity: 'visionmedia'
      repository: 'express'
      coverage: 0.99

    $rootScope.projects.push DataProvider.getDataForProject expressParams

    angularParams =
      displayName: 'Angular'
      entity: 'angular'
      repository: 'angular.js'
      coverage: 0.8

    $rootScope.projects.push DataProvider.getDataForProject angularParams

    updateScore = (project) ->
      project.score = Score.compute project

    # Assign a unique id to each project and calculate its score for the first time
    for project in $rootScope.projects
      project.id = $rootScope.projects.indexOf project
      updateScore project

    updateRandomData = ->
      for project in $rootScope.projects
        if project.random
          RandomDataGenerator.updateProject project
          updateScore project

    $interval updateRandomData, 100

.run (ProjectDataRetriever) ->
  ProjectDataRetriever

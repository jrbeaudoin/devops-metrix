angular.module('metrix.dashboard')

.service 'Score', ->
  compute: (project) ->
    score = 0

    timeSinceLastDeployed = new Date() - project.deployedOn

    weekInSeconds = 1000 * 5 * 60 * 24 * 7
    if project.random
      weekInSeconds = 1000 * 5 # Random data are accelerated

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

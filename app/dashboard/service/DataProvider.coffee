angular.module('metrix.dashboard')

.factory 'DataProvider',
  ($q, $http) ->
    getContributors = (url) ->
      deferred = $q.defer()
      $http
        method: 'GET'
        url: url
      .success (data) ->
        deferred.resolve if data.length then data.length else 0
      .error ->
        deferred.resolve 0

      deferred.promise

    getCommits = (url) ->
      deferred = $q.defer()
      $http
        method: 'GET'
        url: url
      .success (data) ->
        if data.all?
          commits = data.all.reduce (sum, currentValue) ->
            sum += currentValue
          , 0
        else
          commits = 0
        deferred.resolve commits
      .error ->
        deferred.resolve 0

      deferred.promise

    getLastDeploy = (url) ->
      deferred = $q.defer()
      $http
        method: 'GET'
        url: url
      .success (data) ->
        if data.length > 0
          lastCommit = data[0]
          deployedOn = lastCommit.commit.committer.date
        else
          now = new Date()
          deployedOn = now.setYear(now.getFullYear() - 1)
        deferred.resolve deployedOn
      .error ->
        now = new Date()
        deferred.resolve now.setYear(now.getFullYear() - 1)

      deferred.promise

    getCI = (url) ->
      deferred = $q.defer()
      $http
        method: 'GET'
        url: url
      .success (data) ->
        ci = {}
        ci.ci = data.length > 0
        lastBuild = data.filter((build) ->
          build.state == 'finished'
        )[0]
        ci.status = lastBuild.result == 0

        deferred.resolve ci
      .error ->
        ci =
          ci: false
          status: false
        deferred.resolve ci

      deferred.promise

    return getDataForProject: (projectParams) ->
      project =
        name: projectParams.displayName
      # Contributors
      getContributors('https://api.github.com/repos/' + projectParams.entity + '/' + projectParams.repository + '/stats/contributors')
      .then (contributors) ->
        project.updated = true if project.contributors != contributors
        project.contributors = contributors

      # Commits
      getCommits('https://api.github.com/repos/' + projectParams.entity + '/' + projectParams.repository + '/stats/participation')
      .then (commits) ->
        project.commits = commits

      # Last deployment
      # I use the last commit on master for now
      getLastDeploy('https://api.github.com/repos/' + projectParams.entity + '/' + projectParams.repository + '/commits')
      .then (deployedOn) ->
        project.deployedOn = deployedOn

      # Build
      getCI('https://api.travis-ci.org/repos/' + projectParams.entity + '/' + projectParams.repository + '/builds')
      .then (ci) ->
        project.ci = ci.ci
        project.ciStatus = ci.status

      project.coverage = projectParams.coverage
      project.online = true
      project.visits = []
      project.errors = []
      return project

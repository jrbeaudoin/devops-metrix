angular.module('metrix.dashboard')

.directive 'metrixProjectsBubbles', ($rootScope) ->
  template: "<svg></svg>"
  link: ($scope, $element) ->
    bubbleId = (node) ->
      node.id
    bubbleName = (node) ->
      node.name
    bubbleScore = (node) ->
      node.score
    bubbleSize = (node) ->
      Math.sqrt node.commits
    bubbleColor = (node) ->
      switch node.ciStatus
        when true
#          return 'rgb(20,201,114)'
          return 'rgb(20,231,134)'
        when false
          return 'rgb(236,24,75)'
    bubbleFillLevel = (node) ->
      switch node.ci
        when true
          return node.coverage
        when false
          return 0
    bubbleBgColor = (node) ->
      'lightgray'
    bubbleOpacity = (node) ->
      now = new Date()
      maxAgeWithoutDeploy = 1000 * 30 # milliseconds
      1 - 0.8 * Math.min (now - node.deployedOn) / maxAgeWithoutDeploy, 1
    getMaxFromNodes = (data) ->
      maxValue = -Infinity
      for node in data
        maxValue = Math.max(maxValue, bubbleSize node)
      return maxValue
    getScaleFactor = (data) ->
      # Get max value
      maxValue = getMaxFromNodes data
      # Create scaleFactor that will ensure circles will fit in the window
      return maxValue / Math.min($('[metrix-projects-bubbles]').width(), $('[metrix-projects-bubbles]').height()) * Math.sqrt(data.length) * 4

    nodeClick = (nodeClicked) ->
      $scope.zoomed = true
      $scope.project = nodeClicked
      force.stop()
      svg.selectAll(".node").classed("hidden", true)
      zoomScale = 3

      nodeFound = node.filter (d) ->
        if d.id == nodeClicked.id
          zoomScale = 0.9 * Math.min(height, 0.5*width) / bubbleSize(d)
        d.id == nodeClicked.id
      nodeGroup = nodeFound[0][0]

      svg.classed("zoom", true)

      d3.select(nodeGroup)
      .classed("hidden", false)
      .transition().duration(300)
      .attr("transform", ->
        "translate(" + 0.5 * width + "," + 0 + ") scale(" + zoomScale + ")"
      )
      .select(".name").attr("dy", "1em")
      # Prevent call to svgClick
      d3.event.stopPropagation()

    svgClick = ->
      $scope.zoomed = false
      svg.classed("zoom", false)
      svg.selectAll(".node")
      .classed("hidden", false)
      svg.selectAll(".name").attr("dy", "0.35em")
      force.resume()

    node = []
    height = $element[0].offsetHeight
    width = $element[0].offsetWidth
    repulsion = 700

    svg = d3.select($element[0]).select("svg")
    defs = svg.append 'svg:defs'
    svg.attr("width", width).attr("height", height)
    force = d3.layout.force().gravity(0.5).friction(.1).size([
      width
      height
    ])

    update = (chartData) ->
      coords = []
      node.each (d) ->
        coords.push
          x: d.x
          y: d.y
        d.fixed = true

      scaleFactor = getScaleFactor chartData
      force.charge((d) ->
        - (bubbleSize(d) / scaleFactor) * repulsion
      ).nodes(chartData)

      node.data(chartData).enter()
      node.data(chartData).exit().remove()
      circle.data(chartData)
      fillCircle.data(chartData)
      projectName.data(chartData)

      circle
      .transition().ease("cubic-in-out")
      .attr("r", (d) ->
        bubbleSize(d) / scaleFactor
      )
      .style 'fill', (d) ->
        'url(#gradient-' + bubbleId(d) + ')'
      .style 'opacity', bubbleOpacity

      fillCircle
      .attr("r", (d) ->
          (bubbleSize(d) - 8) / scaleFactor
      )
      .style 'fill', 'lightgray'

      projectName.text(bubbleName)
      .attr("class", "name")

      node.each((d, i) ->
        d.fixed = false
        d.x = coords[i].x
        d.y = coords[i].y
      )
      force.start()

    chartData = $rootScope.projects

    force.chargeDistance(500)
    node = svg
    .selectAll(".node")
    .data(chartData)
    .enter()
    .append("g")
    .attr("class", "node")
    .call(force.drag)

    svg.selectAll(".node").on "click", (d) ->
      if (d3.event.defaultPrevented) then return
      nodeClick(d)
    svg.on "click", svgClick

    circlesContainer = node.append("g").attr("class", "circles-container")

    circle = circlesContainer.append("circle")
    .style 'fill', (d) ->
      'url(#gradient-' + bubbleId(d) + ')'

    fillCircle = circlesContainer.append("circle").attr("class", "fill-circle")


    projectScore = node
    .append 'text'
    .attr 'x', 0
    .attr 'y', 0
    .attr 'class', 'project-score'

    projectName = node
    .append("text")
    .attr("dy", "0.35em")
    .attr("x", 0)
    .attr("y", 0)

    gradient = defs
    .selectAll 'linearGradient'
    .data(chartData)
    .enter()
    .append 'svg:linearGradient'
    .attr 'id', (d) -> 'gradient-'+bubbleId d
    .attr 'x1', '0%'
    .attr 'y1', '100%'
    .attr 'x2', '0%'
    .attr 'y2', '0%'

    gradient.append 'stop'
    .attr 'class', 'fg-stop'
    .attr 'offset', bubbleFillLevel
    .attr 'stop-color', bubbleColor
    gradient.append 'stop'
    .attr 'class', 'bg-stop'
    .attr 'stop-color', bubbleBgColor

    update chartData

    force.on "tick", ->
      node.attr "transform", (d) ->
        "translate(" + d.x + "," + d.y + ")"

    $rootScope.$watch 'projects', ->
      chartData = $rootScope.projects
      circle.data(chartData)
      scaleFactor = getScaleFactor chartData

      updatedProjects = $rootScope.projects.filter (project) -> project.updated

      updatedNodes = []
      for project in updatedProjects
        foundNode = node.filter (d) ->
          d.id == project.id
        if foundNode
          updatedNodes.push foundNode[0][0]
          d3.select(foundNode[0][0])
          .select(".fill-circle")
          .transition("ease").duration(100)
          .style 'fill', 'white'
          .transition("ease").duration(800)
          .delay(100)
          .style 'fill', 'lightgray'

      circle
      .attr "r", (d) ->
        bubbleSize(d) / scaleFactor
      circlesContainer
      .style 'opacity', bubbleOpacity
      .classed "offline", (d) -> return !d.online

      gradient
      .selectAll '.fg-stop'
      .attr 'offset', bubbleFillLevel
      .attr 'stop-color', bubbleColor

      gradient
      .selectAll '.bg-stop'
      .attr 'offset', bubbleFillLevel

      projectScore.text bubbleScore
      .attr 'dy', (d) ->
        0.55 * bubbleSize(d) / scaleFactor
      .attr 'font-size', (d) ->
        ( 1.5 * bubbleSize(d) / scaleFactor ) + 'px'
    , true

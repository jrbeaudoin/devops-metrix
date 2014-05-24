angular.module('metrix.dashboard')

.directive 'metrixProjectsBubbles', ($rootScope, $location) ->
  template: "<svg></svg>"
  link: ($scope, $element) ->
    bubbleId = (node) ->
      node.id
    bubbleName = (node) ->
      node.name
    bubbleSize = (node) ->
      Math.sqrt node.commits
    bubbleColor = (node) ->
      switch node.ciStatus
        when true
          return '#5FF06B'
        when false
          return '#FF3C48'
    bubbleFillLevel = (node) ->
      node.coverage
    bubbleBgColor = (node) ->
      'gray'
    bubbleOpacity = (node) ->
      now = new Date()
      maxAgeWithoutDeploy = 1000 * 30 # milliseconds
      1 - 0.8 * Math.min (now - node.deployedOn) / maxAgeWithoutDeploy, 1
    getMaxFromNodes = (data, valueName = "value") ->
      maxValue = -Infinity
      for node in data
        maxValue = Math.max(maxValue, bubbleSize node)
      return maxValue
    getScaleFactor = (data) ->
      # Get max value
      maxValue = getMaxFromNodes data
      # Create scaleFactor that will ensure circles will fit in the window
      return maxValue / Math.min(window.innerWidth, window.innerHeight) * data.length

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
      projectName.data(chartData)

      circle
      .transition().ease("cubic-in-out")
      .attr("r", (d) ->
        bubbleSize(d) / scaleFactor
      )
      .style 'fill', (d) ->
        'url(#gradient-' + bubbleId(d) + ')'
      .style 'opacity', bubbleOpacity

      projectName.text (d) ->
        d.name

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
    .append("svg:a")
    .call(force.drag)

    node.attr("xlink:href", (d) ->
      "/#/project/" + d.name
    )

    circle = node.append("circle")
    projectName = node
    .append("text")
    .attr("dy", "0em")
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
    .attr 'offset', 0
    .attr 'stop-color', bubbleColor
    gradient.append 'stop'
    .attr 'offset', bubbleFillLevel
    .attr 'stop-color', bubbleColor
    gradient.append 'stop'
    .attr 'offset', bubbleFillLevel
    .attr 'stop-color', bubbleBgColor
    gradient.append 'stop'
    .attr 'offset', 100
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
          .select("circle")
          .style("stroke-width", "5px")
          .transition("easeOut").duration(400)
          .delay(200)
          .style("stroke-width", "0px")

      circle
      .attr "r", (d) ->
        bubbleSize(d) / scaleFactor
      .style 'fill', (d) -> 'url(#gradient-'+bubbleId(d)+')'
      .style 'opacity', bubbleOpacity
    , true

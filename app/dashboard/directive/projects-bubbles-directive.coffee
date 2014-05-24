angular.module('metrix.dashboard')

.directive 'metrixProjectsBubbles', ($rootScope, $location) ->
  template: "<svg></svg>"
  link: ($scope, $element) ->
    bubbleSize = (node) ->
      Math.sqrt node.commits
    bubbleColor = (node) ->
      switch node.ciStatus
        when true
          return 'green'
        when false
          return 'red'
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
        bubbleColor d
      .style 'opacity', (d) ->
        bubbleOpacity d

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
    .call(force.drag)

    circle = node.append("circle")
    projectName = node
    .append("text")
    .attr("dy", "0em")
    .attr("x", 0)
    .attr("y", 0)

    update chartData

    node.on "click", (d) ->
      $location.url("/project/" + d.name)
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
          d.name == project.name
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
      .style 'fill', (d) ->
        bubbleColor d
      .style 'opacity', (d) -> bubbleOpacity d
    , true

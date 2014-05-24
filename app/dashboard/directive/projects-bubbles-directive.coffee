angular.module('metrix.dashboard')

.directive 'metrixProjectsBubbles', ($rootScope) ->
  template: "<svg></svg>"
  link: ($scope, $element) ->
    bubbleSize = (node) ->
      Math.sqrt node.commits
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

      #scaleFactor = getScaleFactor chartData
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
      .style("fill", "gray")

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

    force.on "tick", (e) ->
      node.attr "transform", (d) ->
        "translate(" + d.x + "," + d.y + ")"

    $rootScope.$watch 'projects', ->
      chartData = $rootScope.projects
      circle.data(chartData)
      scaleFactor = getScaleFactor chartData
      circle.transition().duration(300).ease("elastic").attr("r", (d) ->
        bubbleSize(d) / scaleFactor
      )
      .style("fill", "gray")
    , true

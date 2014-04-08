layout = (graph) ->
  color = d3.scale.category20()

  width = $('#content').width()
  height = document.height || 800

  force = d3.layout.force()
      .charge(-1200)
      .linkDistance(100)
      .size([width, height])
      .nodes(graph.nodes)
      .links(graph.links)
      .start()

  svg = d3.select("#content")
      .append("svg")
      .attr("width", width)
      .attr("height", height)

  link = svg.selectAll("line.link")
      .data(graph.links)
    .enter()
      .append("line")
      .attr("class", "link")
      .style("stroke-width", 1.5)
  node = svg.selectAll("circle.node")
      .data(graph.nodes)
    .enter()
      .append("circle")
      .attr("id", (d) -> "n#{d.name}")
      .attr("class", "node")
      .attr("r", 5)
      .style("fill", (d) -> color(d.group))
      .call(force.drag)

  node.append("title").text((d) -> d.name)

  force.on "tick", ->
    link
        .attr("x1", (d) -> d.source.x)
        .attr("y1", (d) -> d.source.y)
        .attr("x2", (d) -> d.target.x)
        .attr("y2", (d) -> d.target.y)

    node
        .attr("cx", (d) -> d.x)
        .attr("cy", (d) -> d.y)

#-------

$ ->
  $.ajax "data.json",
    data:
      graph: $('#graph').val()
    dataType: 'json'
    success: (result) ->
      if result.error
        $('#alert-header').text result.type
        $('#alert-text').text result.message
        $('#alert').show()
      else
        layout result
    error: (xhr, text, err) ->
      alert err + ': ' + text




var svg = d3.select("svg"),
    width = +svg.attr("width"),
    height = +svg.attr("height"),
    node,
    edgepaths,
    link;

// build the arrow.
svg.append("svg:defs").selectAll("marker")
    .data(["end"])      // Different link/path types can be defined here
    .enter().append("svg:marker")    // This section adds in the arrows
    .attr("id", String)
    .attr("viewBox", "0 -5 10 10")
    .attr("refX", 15)
    .attr("refY", -1.5)
    .attr("markerWidth", 9)
    .attr("markerHeight",9)
    .attr("orient", "auto")
    .append("svg:path")
    .attr("d", "M0,-5L10,0L0,5")
    .attr('fill', '#999');

var color = d3.scaleOrdinal(d3.schemeCategory20);

var simulation = d3.forceSimulation()
    .force("link", d3.forceLink().id(function(d) { return d.id; }).strength(0.01))
    .force("charge", d3.forceManyBody())
    .force("center", d3.forceCenter(width / 2, height / 2));

d3.json("/static/data/q(1).json", function(error, graph) {
    if (error) throw error;
    update(graph.links, graph.nodes);
});

function update(links, nodes){
    link = svg.selectAll(".links")
        .data(links);
    link.exit().remove();

    link = link.enter().append("line")
        .attr("class", "links")
        .attr('marker-end','url(#end)').merge(link);

    edgepaths = svg.selectAll(".edgepath")
        .data(links);

    edgepaths.exit().remove();
    edgepaths = edgepaths.enter()
        .append('path')
        .attr('class', 'edgepath')
        .attr('fill-opacity', 0)
        .attr('stroke-opacity', 0)
        .attr('id', function (d, i) {return 'edgepath' + i})
        .style("pointer-events", "none").merge(edgepaths);

    node = svg.selectAll('.nodes')
        .data(nodes);

    node.exit().remove();

    node = node.enter().append("g")
        .attr("class", "nodes")
        .call(d3.drag()
                .on("start", dragstarted)
                .on("drag", dragged)
            .on("end", dragended)).merge(node);
        // );

    node.append("circle")
        .attr("r", 6);
    // .attr("fill", function(d) { return color(d.group); })

    node.append("title")
        .text(function(d) { return d.id; });

    node.append("text")
        .text(function(d) {
            return d.id;
        })
        .attr('dx', 8)
        .attr('dy', -3);

    simulation
        .nodes(nodes)
        .on("tick", ticked);

    simulation.force("link")
        .links(links);
    simulation.alpha(0.3).restart();
    function ticked() {
        link
            .attr("x1", function(d) { return d.source.x; })
            .attr("y1", function(d) { return d.source.y; })
            .attr("x2", function(d) { return d.target.x; })
            .attr("y2", function(d) { return d.target.y; });

        node
            .attr("transform", function(d) {
                return "translate(" + d.x + "," + d.y + ")";
            });

        edgepaths.attr('d', function (d) {
            return 'M ' + d.source.x + ' ' + d.source.y + ' L ' + d.target.x + ' ' + d.target.y;
        });
    }

    function dragstarted(d) {
        if (!d3.event.active) simulation.alphaTarget(0.4).restart();
        d.fx = d.x;
        d.fy = d.y;
    }

    function dragged(d) {
        d.fx = d3.event.x;
        d.fy = d3.event.y;
    }

    function dragended(d) {
        if (!d3.event.active) simulation.alphaTarget(0.1);
        d.fx = null;
        d.fy = null;
    }
}
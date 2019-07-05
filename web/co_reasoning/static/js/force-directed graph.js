var svg = d3.select("svg"),
    width = $("#svg_for_vis").width(),
    height = $("#svg_for_vis").height(),
    node,
    edgepaths,
    link,
    selected_node, selected_target_node,
    selected_link, new_line,
    should_drag = false,
    drawing_line = false;
var g = svg.append("g")
    .attr("class", "everything");

d3.select(window)
    .on("keydown", keydown)
    .on("keyup", keyup)
    .on("mousemove", mousemove)
    .on("mouseup", mouseup)
// d3.select("#content").on("mousemove", mousemove)
//     .on("mouseup", mouseup)

// svg.append("rect")
//     .attr("width", width)
//     .attr("height", height)
//     .on("mousedown", mousedown);

// build the arrow.
svg.append("svg:defs").selectAll("marker")
    .data(["end"])      // Different link/path types can be defined here
    .enter().append("svg:marker")    // This section adds in the arrows
    .attr("id", String)
    .attr("viewBox", "0 -5 10 10")
    .attr("refX", 17)
    .attr("refY", 0)
    .attr("markerWidth", 9)
    .attr("markerHeight",9)
    .attr("orient", "auto")
    .append("svg:path")
    .attr("d", "M0,-5L10,0L0,5")
    .attr('fill', '#999');

var simulation = d3.forceSimulation()
    .force("link", d3.forceLink().id(function(d) { return d.id; }))
    .force("charge", d3.forceManyBody())
    .force("center", d3.forceCenter(width / 2, height / 2));

var node_data = [],
    link_data = [];

d3.json("/static/data/q(1).json", function(error, graph) {
    if (error) throw error;
    node_data = graph.nodes;
    link_data = graph.links;
    update(link_data, node_data);
});

// add zoom on svg
d3.select("svg")
    .call(d3.zoom().on("zoom", function () {
        g.attr("transform", d3.event.transform);
    }))
    .on("dblclick.zoom", null);

var linkg = g.append("g"), edgeg = g.append("g"), nodeg = g.append("g");
function update(links, nodes){
    link = linkg.selectAll(".links")
        .data(links);

    link = link.enter().append("line")
        .attr("class", "links")
        .attr('marker-end','url(#end)').merge(link);
    link.exit().remove();

    // edgepaths = edgeg.selectAll(".edgepath")
    //     .data(links);
    //
    // edgepaths = edgepaths.enter()
    //     .append('path')
    //     .attr('class', 'edgepath')
    //     .attr('fill-opacity', 0)
    //     .attr('stroke-opacity', 0)
    //     .attr('id', function (d, i) {return 'edgepath' + i})
    //     .style("pointer-events", "none").merge(edgepaths);
    // edgepaths.exit().remove();

    var node = nodeg.selectAll('.nodes')
        .data(nodes)
        .classed("selected", function(d) { return d === selected_node; })
        .classed("selected_target", function(d) { return d === selected_target_node; });

    var node_g = node.enter().append("g")
        .attr("class", "nodes")
        .call(d3.drag()
                .on("start", dragstarted)
                .on("drag", dragged));
            // .on("end", dragended))
        // );

    node_g.append("circle")
        .attr("r", 6)
        .on("mousedown", node_mousedown)
        .on("mouseover", node_mouseover)
        .on("mouseout", node_mouseout);

    node_g.append("text")
        .text(function(d) {
            return d.id;
        })
        .attr('dx', 8)
        .attr('dy', -3)
        .attr("data-toggle", "modal")
        .attr("data-target", "#exampleModal")
        .attr("data-whatever", function (d) {
            return d.id;
        });

    node.exit().remove();
    // node_g.attr("transform", function(d) {
    //     console.log(d.index);
    //     return "translate(" + d.x + "," + d.y + ")";
    // });
    simulation
        .nodes(nodes)
        .on("tick", ticked);

    simulation.force("link")
        .links(links);
    simulation.alpha(0.3).restart();

    // set positions for nodes
    // node.each(function(d) {
    //     d.fx = width / 2;
    //     d.fy = height;
    // });

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

        // edgepaths.attr('d', function (d) {
        //     return 'M ' + d.source.x + ' ' + d.source.y + ' L ' + d.target.x + ' ' + d.target.y;
        // });
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

    // function dragended(d) {
    //     if (!d3.event.active) simulation.alphaTarget(0.1);
    //     d.fx = null;
    //     d.fy = null;
    // }
}

// select target node for new node connection
function node_mouseover(d) {
    d3.select(this).transition()
        .duration(150)
        .attr("r", 10);
    if (drawing_line && d !== selected_node) {
        // highlight and select target node
        selected_target_node = d;
    }
}

function node_mouseout(d) {
    d3.select(this).transition()
        .duration(150)
        .attr("r", 6);

    if (drawing_line) {
        selected_target_node = null;
    }
}

// select node / start drag
function node_mousedown(d) {
    if (!drawing_line) {
        selected_node = d;
        selected_link = null;
    }
    if (!should_drag) {
        d3.event.stopPropagation();
        drawing_line = true;
    }
    // d.fixed = true;
    simulation.stop();
    update(link_data, node_data);
    simulation.restart();
}

// draw yellow "new connector" line
function mousemove() {
    d3.event.preventDefault();
    if (drawing_line && !should_drag) {
        var m = d3.mouse(d3.select("svg").node());
        m = d3.zoomTransform(d3.select("svg").node()).invert(m);
        var x = Math.max(0, Math.min(width, m[0]));
        var y = Math.max(0, Math.min(height, m[1]));
        // debounce - only start drawing line if it gets a bit big
        var dx = selected_node.x - x;
        var dy = selected_node.y - y;
        if (Math.sqrt(dx * dx + dy * dy) > 10) {
            // draw a line
            if (!new_line) {
                new_line = linkg.append("line").attr("class", "new_line");
            }
            new_line.attr("x1", function(d) { return selected_node.x; })
                .attr("y1", function(d) { return selected_node.y; })
                .attr("x2", function(d) { return x; })
                .attr("y2", function(d) { return y; });
        }
    }
    update(link_data, node_data);
}

// end node select / add new connected node
function mouseup() {
    drawing_line = false;
    if (new_line) {
        if (selected_target_node) {
            selected_target_node.fixed = false;
            var new_node = selected_target_node;

            // else {
            //     var m = d3.mouse(svg.node());
            //     var new_node = {x: m[0], y: m[1], name: default_name + " " + nodes.length, group: 1}
            //     nodes.push(new_node);
            // }
            selected_node.fixed = false;
            link_data.push({source: selected_node, target: new_node})
            selected_node = selected_target_node = null;
            update(link_data, node_data);
        }
        setTimeout(function () {
            new_line.remove();
            new_line = null;
            simulation.restart();
        }, 30);
    }
}

function keyup() {
    switch (d3.event.keyCode) {
        case 16: { // shift
            should_drag = false;
            update(link_data, node_data);
            simulation.restart();
        }
    }
}

// select for dragging node with shift; delete node with backspace
function keydown() {
    switch (d3.event.keyCode) {
        case 8: // backspace
        case 46: { // delete
            if (selected_node) { // deal with nodes
                var i = node_data.indexOf(selected_node);
                node_data.splice(i, 1);
                // find links to/from this node, and delete them too
                var new_links = [];
                link_data.forEach(function(l) {
                    // console.log(l);
                    // console.log(selected_node);
                    if (l.source.id !== selected_node.id && l.target.id !== selected_node.id) {
                        new_links.push(l);
                    }
                });
                link_data = new_links;
                // selected_node = node_data.length ? nodes[i > 0 ? i - 1 : 0] : null;
            } else if (selected_link) { // deal with links
                var i = link_data.indexOf(selected_link);
                link_data.splice(i, 1);
                // selected_link = link_data.length ? links[i > 0 ? i - 1 : 0] : null;
            }
            update(link_data, node_data);
            break;
        }
        case 16: { // shift
            should_drag = true;
            break;
        }
    }
}
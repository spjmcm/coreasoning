var svg = d3.select("svg"),
    width = $("#svg_for_vis").width(),
    height = $("#svg_for_vis").height(),
    selected_node, selected_target_node,
    selected_link, new_line, insert_link,
    circlesg, linesg,
    should_drag = false,
    drawing_line = false,
    nodes = [],
    links = [],
    link_distance = 90;

var default_name = "new node"

var force = d3.layout.force()
    .charge(-340)
    .linkDistance(link_distance)
    .size([width, height]);

d3.select(window)
    .on("keydown", keydown)
    .on("keyup", keyup);

d3.select("#content").on("mousemove", mousemove)
    .on("mouseup", mouseup)

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
    .attr("refX", 14)
    .attr("refY", 0)
    .attr("markerWidth", 4)
    .attr("markerHeight",4)
    .attr("orient", "auto")
    .append("svg:path")
    .attr("d", "M0,-5L10,0L0,5")
    .attr('fill', '#999');


linesg = svg.append("g");
circlesg = svg.append("g");

d3.json("/static/data/q(1).json", function(json) {
    // decorate a node with a count of its children
    nodes = json.nodes;
    links = json.links;
    update();
    force = force
        .nodes(nodes)
        .links(links);
    force.start();
});


function update() {
    var link = linesg.selectAll("line.link")
        .data(links)
        .attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; })
        .classed("selected", function(d) { return d === selected_link; });
    link.enter().append("line")
        .attr("class", "link")
        .attr("marker-end", "url(#end)")
        .on("mousedown", line_mousedown);
    link.exit().remove();

    var node = circlesg.selectAll(".node")
        .data(nodes, function(d) {return d.id;})
        .classed("selected", function(d) { return d === selected_node; })
        .classed("selected_target", function(d) { return d === selected_target_node; })
    var nodeg = node.enter()
        .append("g")
        .attr("class", "node").call(force.drag)
        // .attr("transform", function(d) {
        //     return "translate(" + width / 2 + "," + height + ")";
        // });
    nodeg.append("circle")
        .attr("r", 6)
        .on("mousedown", node_mousedown)
        .on("mouseover", node_mouseover)
        .on("mouseout", node_mouseout);
    nodeg
        .append("text")
        .attr("dx", 12)
        .attr("dy", ".35em");
    node.selectAll("text")
        .text(function(d) {
            return d.id})
        .attr("data-toggle", "modal")
        .attr("data-target", "#exampleModal")
        .attr("data-whatever", function (d) {
            return d.id;
        });
    node.exit().remove();

    // set positions for nodes
    // node.each(function(d) {
    //     d.x = width / 2;
    //     d.y = height;
    // });

    force.on("tick", function(e) {
        link.attr("x1", function(d) { return d.source.x; })
            .attr("y1", function(d) { return d.source.y; })
            .attr("x2", function(d) { return d.target.x; })
            .attr("y2", function(d) { return d.target.y; });
        node.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
    });
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
    d.fixed = true;
    force.stop()
    update();
}

// select line
function line_mousedown(d) {
    selected_link = d;
    selected_node = null;
    update();
}

// draw yellow "new connector" line
function mousemove() {
    d3.event.preventDefault();
    if (drawing_line && !should_drag) {
        var m = d3.mouse(svg.node());
        var x = Math.max(0, Math.min(width, m[0]));
        var y = Math.max(0, Math.min(height, m[1]));
        // debounce - only start drawing line if it gets a bit big
        var dx = selected_node.x - x;
        var dy = selected_node.y - y;
        if (Math.sqrt(dx * dx + dy * dy) > 10) {
            // draw a line
            if (!new_line) {
                new_line = linesg.append("line").attr("class", "new_line");
            }
            new_line.attr("x1", function(d) { return selected_node.x; })
                .attr("y1", function(d) { return selected_node.y; })
                .attr("x2", function(d) { return x; })
                .attr("y2", function(d) { return y; });
        }
    }
    update();
}

var insert_link = null;
// end node select / add new connected node
function mouseup() {
    drawing_line = false;
    if (new_line) {
        if (selected_target_node) {
            selected_target_node.fixed = false;
            var new_node = selected_target_node, source_node = selected_node;
            selected_node.fixed = false;
            var rules = {}
            links.forEach(function (l) {
                if(l.target.id === new_node.id){
                    if(!(l.name in rules)){
                        rules[l.name] = {}
                        rules[l.name]["conclusion"] = l.target.id
                        rules[l.name]["conditions"] = []
                    }
                    rules[l.name]["conditions"].push(l.source.id);
                }
            });
            $("#edge_dropdown").empty();
            var rule_text = "";
            for(var key in rules){
                for(var i = 0; i < rules[key]["conditions"].length; i++){
                    var c = rules[key]["conditions"][i];
                    rule_text += c.substring(0, c.length - 5);
                    if(i != rules[key]["conditions"].length - 1)
                        rule_text += " + ";
                }
                rule_text += " = " + rules[key]["conclusion"];
                $("#edge_dropdown").append("<button class=\"dropdown-item\" type=\"button\" name=" + key + ">" + rule_text + "</button>");
            }
            $("#edge_dropdown").append("<button class=\"dropdown-item\" type=\"button\" name=\"new\">new rule</button>");
            $(".dropdown-item").click(function () {
                insert_link = {name: "", source: source_node, target: new_node};
                var rule_id = $(this)[0].name, input_text = "";
                insert_link.name = "";
                if(rule_id.length > 0){
                    if(rule_id in rules){
                        input_text = source_node.id.substring(0, source_node.id.length - 5) + " + " + rule_text;
                        insert_link.name = rule_id;
                    }
                    else{
                        input_text = source_node.id.substring(0, source_node.id.length - 5) + " = " + new_node.id.substring(0, new_node.id.length - 5);
                    }
                }
                $("#edge_input").val(input_text);
            });
            $("#edgeModal").modal();
            selected_node = selected_target_node = null;
        }
        // setTimeout(function () {
        //     new_line.remove();
        //     new_line = null;
        //     force.start();
        //     }, 30);
        
    }
}

$("#edge_modal_save").click(function () {
    force.stop();
    if(insert_link != null){
        links.push(insert_link);
        update();
    }
    if(new_line != null){
        new_line.remove();
        new_line = null;
    }
    force.start();
    $('#edgeModal').modal('hide');
    insert_link = null;
});

function keyup() {
    switch (d3.event.keyCode) {
        case 16: { // shift
            should_drag = false;
            update();
            force.start();
        }
    }
}

// select for dragging node with shift; delete node with backspace
function keydown() {
    switch (d3.event.keyCode) {
        case 8: // backspace
        case 46: { // delete
            if (selected_node) { // deal with nodes

                var i = nodes.indexOf(selected_node);
                nodes.splice(i, 1);
                // find links to/from this node, and delete them too
                var new_links = [];
                links.forEach(function(l) {
                    if (l.source !== selected_node && l.target !== selected_node) {
                        new_links.push(l);
                    }
                });
                links = new_links;
                selected_node = nodes.length ? nodes[i > 0 ? i - 1 : 0] : null;
            } else if (selected_link) { // deal with links
                var i = links.indexOf(selected_link);
                links.splice(i, 1);
                selected_link = links.length ? links[i > 0 ? i - 1 : 0] : null;
            }
            update();
            break;
        }
        case 16: { // shift
            should_drag = true;
            break;
        }
    }
}

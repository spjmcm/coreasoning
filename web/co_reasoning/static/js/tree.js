var margin = {top: 20, right: 5, bottom: 20, left: 5},
    height = 500 - margin.top - margin.bottom,
    width = $("#svg_for_vis").width() - margin.left - margin.right,
    timeout = null;

// append the svg object to the body of the page
// appends a 'group' element to 'svg'
// moves the 'group' element to the top left margin
var svg = d3.select("svg")
    .append("g")
    .attr("transform", "translate(" + 0 + "," + 0 + ")");

// add zoom on svg
d3.select("svg")
    .call(d3.zoom().on("zoom", function () {
        // var transform = d3.event.transform;
        svg.attr("transform", d3.event.transform);
    }))
    .on("dblclick.zoom", null);

// build the arrow.
svg.append("svg:defs").selectAll("marker")
    .data(["end"])      // Different link/path types can be defined here
    .enter().append("svg:marker")    // This section adds in the arrows
    .attr('id', String)
    .attr('viewBox', '0 -5 10 10')
    .attr("refX", 3)
    .attr("refY", -0)
    .attr('markerWidth', 6)
    .attr('markerHeight', 6)
    .attr('orient', 'auto')
    .attr('class', 'arrow')
    .append('path')
    .attr('d', 'M0,-5L10,0L0,5');

var i = 0,
    duration = 750,
    root,
    clicked_node = null;

// declares a tree layout and assigns the size
var treemap = d3.tree().size([height, width]),
    queue = [];

d3.json("/static/tree_data/q(1).json", function (error, treeData) {
    // Assigns parent, children, height, depth
    root = d3.hierarchy(treeData, function(d) { return d.children; });
    root.x0 = width / 2;
    root.y0 = height;
// Collapse after the second level
    root.children.forEach(collapse);
    queue.push(treeData);
    bfs(queue, 1);
    update(root);
});

// Collapse the node and all it's children
function collapse(d) {
    if(d.children) {
        d._children = d.children
        d._children.forEach(collapse)
        d.children = null
    }
}

// add text rules
function bfs(q, num) {
    var count = 0;
    for(var i = 0; i < num; i++){
        var node = q.shift(),
            id = node.id,
            children = node.children,
            name = node.name,
            text = id + " <- ";
        for(var j = 0; j < children.length; j++){
            text += children[j].id;
            if(j != children.length - 1)
                text += " + "
            if('children' in children[j]){
                q.push(children[j]);
                count++;
            }
        }
        $("#text_explain").prepend("<p class='natural_language_text'>" + text + "</p>")
    }
    if(count > 0) bfs(q, count);
}

function update(source) {
    // Assigns the x and y position for the nodes
    var treeData = treemap(root);
    // $("#text_explain").prepend("<div></div>")

    // Compute the new tree layout.
    var nodes = treeData.descendants(),
        links = treeData.descendants().slice(1);
    // Normalize for fixed-depth
    nodes.forEach(function(d){ d.y = height - d.depth*100 });

    // **************** Nodes Section ****************

    // Update the nodes...
    var node = svg.selectAll('g.node')
        .data(nodes, function(d) {return d.id || (d.id = ++i); });

    // Enter any new nodes at the parent's previous position.
    var nodeEnter = node.enter().append('g')
        .attr('class', 'node')
        .attr("transform", function(d){
            return "translate(" + source.x0 + "," + source.y0 + ")";
        });

    // Add Circle for the nodes
    nodeEnter.append('circle')
        .attr('class', 'node')
        .attr('r', 1e-6)
        .attr("stroke", "steelblue")
        .on("mouseover", function (d) {
                d3.select(this).transition()
                    .duration(150)
                    .attr("r", 10);
            }
        )
        .on("mouseout", function (d) {
                d3.select(this).transition()
                    .duration(150)
                    .attr("r", 6);
            }
        )
        .attr('name', function (d) {
            return d.data.id;
        })
        .style("fill", function(d){
            return d._children ? "lightsteelblue" : "#fff";
        })
        .on('click', click)
        .on("dblclick",function(d){
            // dbclick a node to remove it
            clearTimeout(timeout);
            if(d.data.id != root.data.id){
                var parent = d.parent.data,
                    node = d.data;
                for(var i = 0; i < parent.children.length; i++){
                    if(parent.children[i].id == node.id){
                        parent.children.splice(i, 1);
                        break;
                    }
                }
                if("children" in node){
                    for(var i = 0; i < node.children.length; i++){
                        parent.children.push(node.children[i]);
                    }
                }
                update_data();
            }
        });

    // Add labels for the nodes
    nodeEnter.append('text')
        .attr("dy", "-.35em")
        .attr("x", function(d){
            return d.children || d._children ? -13 : 13;
        })
        .attr("text-anchor", function(d){
            return d.children || d._children ? "end" : "start";
        })
        .text(function(d){ return d.data.id; })
        .attr("data-toggle", "modal")
        .attr("data-target", "#exampleModal")
        .attr("data-whatever", function (d) {
            return d.data.id;
        });

    // Update
    var nodeUpdate = nodeEnter.merge(node);

    // Transition to the proper position for the nodes
    nodeUpdate.transition()
        .duration(duration)
        .attr("transform", function(d) {
            return "translate(" + d.x + "," + d.y + ")";
        });

    // Update the node attributes and style
    nodeUpdate.select('circle.node')
        .attr('r', 6)
        .style("fill", function(d){
            return d._children ? "lightsteelblue" : "#fff";
        })
        .attr('cursor', 'pointer');

    // Remove any exiting nodes
    nodeExit = node.exit().transition()
        .duration(duration)
        .attr("transform", function(d){
            return "translate(" + source.x +","+ source.y +")";
        })
        .remove();

    // On exit reduce the node circles size to 0
    nodeExit.select('circle')
        .attr('r', 1e-6);

    // On exit reduce the opacity of text lables
    nodeExit.select('text')
        .style('fill-opacity', 1e-6)

    // **************** Links Section ****************

    // Update the links...
    var link = svg.selectAll('path.link')
        .data(links, function(d){ return d.id; });

    // Enter any new links at the parent's previous position
    var linkEnter = link.enter().insert('path', "g")
        .attr("class", "link")
        .attr('d', function(d){
            var o = {x: source.x0, y: source.y0};
            return diagonal(o,o);
        })
        .attr('marker-end', 'url(#end)');

    // Update
    var linkUpdate = linkEnter.merge(link);

    // Transition back to the parent element position
    linkUpdate.transition()
        .duration(duration)
        .attr('d', function(d){ return diagonal(d, d.parent) });

    // Remove any existing links
    var linkExit = link.exit().transition()
        .duration(duration)
        .attr('d', function(d) {
            var o = {x: source.x, y: source.y}
            return diagonal(o, o)
        })
        .remove();

    // Store the old positions for transition.
    nodes.forEach(function(d){
        d.x0 = d.x;
        d.y0 = d.y;
    });

    // Create a curved (diagonal) path from parent to the child nodes
    function diagonal(s,d){
        path = "M" + (s.x) + "," + (s.y)
            + "V" + ((3*s.y + 4*d.y)/7)
            + "H" + d.x
            + "V" + (d.y - 15);
        return path;
    }

    // Toggle children on click
    function click(d){
        clearTimeout(timeout);
        var ctrlKey = d3.event.metaKey,
            node = d3.select(this);
        timeout = setTimeout(function() {
            if (ctrlKey){
                // if click with ctrlKey, move a node to another node
                var clicked = node.attr("stroke") == "red";

                // check whether a node has been selected
                if(clicked){
                    clicked_node = null;
                    node.attr("stroke", "steelblue");
                }
                else{
                    // when there are two nodes selected, move the first one and set it as a child of the second one
                    if(clicked_node == null){
                        clicked_node = d;
                    }
                    else{
                        var node1 = dfs_link(root.data, clicked_node.data, null, null),
                            node2 = dfs_link(root.data, node1, null, d.data);
                        console.log(root.data);
                        update_data();
                        clicked_node = null;
                    }
                    node.attr("stroke", "red");
                }
            }
            else{
                // normal click, expand or collapse the tree
                if (d.children){
                    d._children = d.children;
                    d.children = null;
                }
                else{
                    d.children = d._children;
                    d._children = null;
                }
                update(d);
            }
        }, 300)
    }
}

function link_two_nodes(n1, n2){
    if(!('children' in n1))
        n1.children = []
    n1.children.push(n2);
    for(var j = 0; j < n2.parent.children.length; j++){
        if(n2.parent.children[j].data.id == n2.data.id)
            n2.parent.children.splice(j, 1);
    }
}

$("#submit").click(function (e) {
    $("#text_explain").empty();
    e.preventDefault();
    queue = [];
    queue.push(root.data);
    bfs(queue, 1);

    // $.ajax({
    //     url:'/co_reasoning/get_dropped_data/',
    //     type: 'GET',
    //     data: change_data,
    //     dataType: 'json',
    //     success: function (data) {
    //         // d3.json("/static/data/q(1)_tmp.json", function(error, graph) {
    //         //     if (error) throw error;
    //         //     update(graph.links, graph.nodes);
    //         //     simulation.re
    //         // });
    //         d3.json("/static/tree_data/q(1)_tmp.json", function (error, treeData) {
    //             // Assigns parent, children, height, depth
    //             root = d3.hierarchy(treeData, function(d) { return d.children; });
    //             root.x0 = width / 2;
    //             root.y0 = height;
    //             root.children.forEach(collapse);
    //
    //             update(root);
    //         });
    //     }
    // })

});

// the input for adding narratives
$("#input_add_node").keypress(function (e) {
    if(e.keyCode == 13){
        var text = $(this).val();
        $("<div class='narrative' draggable='true' ondragstart='drag(event)' id='drag" + narrative_count + "'>" +
            text + "</div>").insertBefore($("#drag" + top_index));
        top_index = narrative_count;
        narrative_count += 1;
    }
})
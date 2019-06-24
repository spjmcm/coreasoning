$(document).ready(function () {
    $.getJSON("/static/tree_data/s(0).json", function (data) {
        $.each( data, function( index, narrative) {
            $('#div1').append("<div class='narrative' draggable='true' ondragstart='drag(event)' id='drag" + index + "'>" +
                narrative + "</div>")
        });
    });
});

function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
    // $("#div2").prepend(document.getElementById(data));
    if (ev.target.nodeName == 'circle'){
        var target = ev.target.getAttribute('name'),
            source = $("#" + data).text(),
            change_data = {
                'target': target,
                'source': source
            };
        // console.log(change_data);
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
        dfs_add_node(root.data, source, target);
        update_data();
    }
}
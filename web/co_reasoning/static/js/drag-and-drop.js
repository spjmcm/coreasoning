var narrative_count = 0, top_index = 0;
$(document).ready(function () {
    $.getJSON("/static/tree_data/s(0).json", function (data) {
        $.each( data, function( index, narrative) {
            $('#list-narrative').append("<li class='narrative nav-item' draggable='true' ondragstart='drag(event)' id='drag" + index + "'>" +
                "<i class='fa fa-circle-o'></i> " + narrative + "</li>");
            narrative_count += 1;
        });
    });

    $('#sidebarCollapse').on('click', function () {
        $('#div1').toggleClass('active');
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
    if (ev.target.nodeName == 'circle'){
        var target = ev.target.getAttribute('name'),
            source = $("#" + data).text();
        if(source.startsWith("-")){
            source = source.slice(1);
            source += "#true";
        }
        else source += "=true";
        dfs_add_node(root.data, source, target);
        update_data();
    }
}
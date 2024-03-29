var narrative_count = 0, top_index = 0;
var text_explain_height, question = "has(ann,doorkeys)";

$(document).ready(function () {
    // flesh out the list of rules from json file
    text_explain_height = $("#text_explain").height();
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

    $(".collapsed").click(function () {
        var card = $("#accordionExample").height(),
            body = $($(".text_body")[0]).height(),
            target = $(this).attr("data-target");
        if($(target).hasClass("show")){
            $("#text_explain").height(text_explain_height);
        }
        else{
            $("#text_explain").height(body - 168 - $(target).height() - $($(".text_header")[0]).height());
        }
    });

    $('#submit').click(function (){
      window.location.href = "wordreplacement";
      return false;
    })
});

//nothing to do during dragging
function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev) {
    ev.preventDefault();
    //get the target id for retrieving the text inside it
    var data = ev.dataTransfer.getData("text");
    var source = $("#" + data).text().trim();
    if(source.startsWith("-")){
        source = source.slice(1);
        source += "#true";
    }
    else source += "=true";

    var x = ev.pageX - document.getElementById("svg_for_vis").getBoundingClientRect().x,
        y = ev.pageY - document.getElementById("svg_for_vis").getBoundingClientRect().y;
    nodes.push({
        id: source,
        x: x,
        y: y,
        index: nodes.length
    });
    force.stop();
    update();
    force.start();
}

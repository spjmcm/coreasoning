var triggerElement;
$('#exampleModal').on('shown.bs.modal', function (event) {
    triggerElement = $(event.relatedTarget);
    var text = $(triggerElement[0]).text();
    $(this).find(".modal-body input").val(text);
});

$("#modal_save").click(function () {
    var changed_text = $("#node_text").val(),
        original_text = $(triggerElement[0]).text();;
    // last_data = $.extend(true, {}, root.data);

    for(var i = 0; i < nodes.length; i++){
        if(nodes[i].id == original_text){
            nodes[i].id = changed_text;
        }
    }
    force.stop();
    update();
    force.start();
    $('#exampleModal').modal('hide');
});
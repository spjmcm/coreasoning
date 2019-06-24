var triggerElement;
$('#exampleModal').on('shown.bs.modal', function (event) {
    triggerElement = $(event.relatedTarget);
    var text = triggerElement.data("whatever");
    $(this).find(".modal-body input").val(text);
});

$("#modal_save").click(function () {
    var changed_text = $("#node_text").val(),
        original_text = triggerElement.data("whatever");
    dfs_replace_node_text(root.data, changed_text, original_text);

    update_data();
    $('#exampleModal').modal('hide');
});
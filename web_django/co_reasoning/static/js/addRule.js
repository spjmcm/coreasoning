$('.add-rule-button').on('click', () => {
  subject = $('#subject').val();
  verb = $('#verb').val()
  object = $('#object').val();
  new_rule = verb+'('+subject+','+object+')';
  $('#list-narrative').append("<li class='narrative nav-item' draggable='true' ondragstart='drag(event)' id='drag" + narrative_count+1 + "'>" +
      "<i class='fa fa-circle-o'></i> " + new_rule + "</li>");
})
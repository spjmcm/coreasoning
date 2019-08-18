$('.add-rule-button').on('click', () => {
  subject = $('#subject').val();
  verb = $('#verb').val()
  object = $('#object').val();
  new_rule = verb+'('+subject+','+object+')';
  has_contain = false;
  $('#list_narrative').each(function() {
    if($(this).text() == new_rule)
    {
      has_contain = true;
    }
  });
  if(has_contain == false)
  {
    $('#list-narrative').append("<li class='narrative nav-item' draggable='true' ondragstart='drag(event)' id='drag" + narrative_count+1 + "'>" +
        "<i class='fa fa-circle-o'></i> " + new_rule + "</li>");
  }

})

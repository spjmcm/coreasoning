$('.add-rule-button').on('click', () => {
  subject = $('#subject').val();
  verb = $('#verb').val()
  object = $('#object').val();
  new_rule = verb+'('+subject+','+object+')';
  has_contain = false;
  $('#list-narrative li').each(function(index) {
    //trim the space around the text
    if($(this).text().trim == new_rule)
    {
      console.log('new rule has existed');
      has_contain = true;
    }
  });
  if(!has_contain)
  {
    $('#list-narrative').append("<li class='narrative nav-item' draggable='true' ondragstart='drag(event)' id='drag" + narrative_count+1 + "'>" +
        "<i class='fa fa-circle-o'></i> " + new_rule + "</li>");
  }

})

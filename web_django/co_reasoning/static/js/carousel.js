$(document).ready(function () {
    // disable automatic carousel
    $('.carousel').carousel({interval: false});
    $('.prev-button').on('click', function() {
      $('.carousel').carousel('prev');
    });
    $('.next-button').on('click', function() {
      $('.carousel').carousel('next');
    });

    initRuleList();
});

function initRuleList(){
  //get the length of json array
  data = $.getJSON("/static/data/rules.json");
  len = data.length();
  for(var i=0; i<data.length; i++)
  {
    $('#list-narrative').append("<li class='narrative nav-item' id='rule" + (i+1) + "'>" +
        "<i class='fa fa-circle-o'></i> " + rule+(i+1) +"</li>")
  }
}

$(document).ready(function () {
    // disable automatic carousel
    $('.carousel').carousel({interval: false});
    $('.prev-button').on('click', function() {
      $('.carousel').carousel('prev');
    });

    $('.next-button').on('click', function() {
      $('.carousel').carousel('next');
    });

    $('.carousel').on('slide.bs.carousel', function(ev){
      var slide_from = $(this).find('.active').index();
      var slide_to = $(ev.relatedTarget).index();
      $('#rule'+slide_from).css('color', 'white');
      $('#rule'+slide_to).css('color', 'red');
    });

    initRuleList();
});

function initRuleList(){
  //display the rule list
  data = $.getJSON("/static/data/rules.json", function(data) {
    $.each(data, function(i, obj)
    {
      $('#list-narrative').append("<li class='narrative nav-item' id='rule"+i + "'>" +
          "<i class='fa fa-circle-o'></i> " + "rule"+(i+1) +"</li>")
    });
  });
};

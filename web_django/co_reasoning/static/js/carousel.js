$(document).ready(function () {
    // disable automatic carousel
    $('.carousel').carousel({interval: false});
    $('.prev-button').on('click', function() {
      $('.carousel').carousel('prev');
    });

    $('.next-button').on('click', function() {
      $('.carousel').carousel('next');
    });

    $('.carousel').on('slid.bs.carousel', function(){
      var frame_index = $(this).find('.active').index();
      console.log('now carousel is on '+frame_index);
      $('#rule'+frame_index).css('color', 'red');
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

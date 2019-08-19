$(document).ready(function () {
    // disable automatic carousel
    $('.carousel').carousel({interval: false});
    $('.prev-button').on('click', function() {
      $('.carousel').carousel('prev');
    });
    $('.next-button').on('click', function() {
      $('.carousel').carousel('next');
    });
});

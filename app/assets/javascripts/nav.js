$(document).on('turbolinks:load', function() {

  $('a#toggle-nav').click(function(e){
    e.preventDefault();
    $('.navbar-collapse').toggleClass('active');
    if($('.navbar-collapse').hasClass('active')){
      $(this).find('i').removeClass('icon-Menu').addClass('icon-close');
    } else {
      $(this).find('i').removeClass('icon-close').addClass('icon-Menu');
    }
  });


});
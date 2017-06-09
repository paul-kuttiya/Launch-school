$(function(){
  $('.dropdown').click(function(e){
    e.stopPropagation();

    if ($(e.target).closest('a').attr('href') === "#") {
      e.preventDefault()
    }
      
    $(this).find('.dropdown-menu').toggleClass('open');
  });
});
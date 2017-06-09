$(function() {
  $('#todos').on('click', 'li p', function(e) {
    e.stopPropagation();
    $(e.target).parent('li').children('.small').toggle();
  });
})
var ready;
ready = function() {
  setTimeout(function() {
    $('#flash').fadeOut(1000);
  }, 3000);
};

$(document).ready(ready);
$(document).on('page:load', ready);

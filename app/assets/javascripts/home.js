$(document).on("click", ".app-item", function() {
  url = $(this).data('app');
  window.location = '/' + url;
});
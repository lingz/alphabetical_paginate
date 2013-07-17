$(function() {
  var text = "<span class='loading'>Loading...</span>"

  $(".pagination a").live("click", function(e) {
      jQuery.getScript(location.href.replace("(letter=?)", "letter=" + this.data("letter")));
      jQuery(".pagination").html(text);
      history.pushState(null, document.title, location.href.replace("(letter=?)", "letter=" + this.data("letter")));
      e.preventDefault();
  });

  $(window).bind("popstate", function() {
      $.getScript(location.href);
      $(".pagination").html(text);
  });
});

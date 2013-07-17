$(function() {
  var text = "<span class='loading'>Loading...</span>"

  $(".pagination a").live("click", function(e) {
      if (/letter/.test(location.href)){
        jQuery.getScript(location.href.replace(/letter\=./, "letter=" + this.data("letter")));
        history.pushState(null, document.title, location.href.replace(/letter\=./, "letter=" + this.data("letter")));
      }
      else {
        jQuery.getScript(location.href + "?letter=" + this.data("letter"));
        history.pushState(null, document.title, location.href + "?letter=" + this.data("letter"));
      }
      jQuery(".pagination").html(text);
      e.preventDefault();
  });

  $(window).bind("popstate", function() {
      $.getScript(location.href);
      $(".pagination").html(text);
  });
});

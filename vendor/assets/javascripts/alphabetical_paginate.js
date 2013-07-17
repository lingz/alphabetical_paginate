console.log('asd');
$(function() {
  var text = "<span class='loading'>Loading...</span>"

  $(".pagination a").on("click", function(e) {
      e.preventDefault();
      if (/letter/.test(location.href)){
        jQuery.getScript(location.href.replace(/letter\=./, "letter=" + this.data("letter")));
        history.pushState(null, document.title, location.href.replace(/letter\=./, "letter=" + this.data("letter")));
      }
      else {
        jQuery.getScript(location.href + "?letter=" + this.data("letter"));
        history.pushState(null, document.title, location.href + "?letter=" + this.data("letter"));
      }
      jQuery(".pagination").html(text);
  });

  $(window).on("popstate", function() {
      $.getScript(location.href);
      $(".pagination").html(text);
  });
});

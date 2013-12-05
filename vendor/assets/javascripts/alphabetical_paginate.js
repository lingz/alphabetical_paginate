$(function() {
  var once = false;

  var img = "<img src='/assets/aloader.gif' class='loading'/>";
  // RAILS 3.0 USERS -> Please delete the above line and uncomment the bottom line
  // ensure that the image directory matches
  // var img = "<img src='/img/aloader.gif' class='loading'/>";

  var navbar = $(".pagination.alpha a");
  // Pick the handler list: just a quick check for the jQuery version (see here: http://bugs.jquery.com/ticket/10589)
  var handlers = navbar.data ? navbar.data('events') : jQuery._data(navbar[0], 'events');

  if (!handlers || -1 !== $.inArray(onNavbarClick, handlers.click)) {
      $(document).on("click", ".pagination.alpha a", onNavbarClick);
  }

  function onNavbarClick(e) {
      e.preventDefault();
      var url = location.href, 
      letter = $(this).data("letter");
      if (/letter/.test(url)) {
          url = url.replace(/letter=[^&]*/, "letter=" + letter);
      } 
      else {
          if (/\?/.test(url)) {
              url += "&letter=" + letter;
          } 
          else {
              url += "?letter=" + letter;
          }
      }
      $(".pagination").html(img);
      //$.load(url + " #pagination_table");
      $.get(url, function(result) {
          $(".pagination").html($(".pagination", result));
          $("#pagination_table").html($("#pagination_table", result));
      });
      history.pushState(null, document.title, url);
  }

   // let navigate the browser throught the ajax history
  $(window).bind("popstate", function() {
    if (once) {
      $(".pagination").html(img);
      $.get(location.href, function(result) {
        $(".pagination").html($(".pagination", result));
          $("#pagination_table").html($("#pagination_table", result));
        });
      } else {
        once = true;
      }
  });


});

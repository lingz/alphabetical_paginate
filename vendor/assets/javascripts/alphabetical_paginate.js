$(function() {
  var once = false;

  // This should get the Rails path really
  var img = "<img src='/assets/aloader.gif' class='loading'/>";
  // RAILS 3.0 USERS -> Please delete the above line and uncomment the bottom line
  // ensure that the image directory matches
  // var img = "<img src='/img/aloader.gif' class='loading'/>";

  var navbar = $(".pagination.alpha a");
  // Pick the handler list: just a quick check for the jQuery version (see here: http://bugs.jquery.com/ticket/10589)
  var handlers = navbar.data ? navbar.data('events') : jQuery._data(navbar[0], 'events');

  // Prevent multiple binding!!!
  if (!handlers || -1 !== $.inArray(onNavbarClick, handlers.click)) {
      $(document).on("click", ".pagination.alpha a", onNavbarClick);
      // Bind popstate only if the pagination is active: 
      // is production this code is always sent with the assets pipeline!
      bindPopState();
  }

  function onNavbarClick(e) {
      e.preventDefault();
      var url = location.href,
          letter = $(this).data("letter");
      if (/letter/.test(url)) {
          url = url.replace(/letter=[^&]*/, "letter=" + letter);
      } else {
          url = ((/\?/.test(url)) ? '&' : '?') + 'letter=' + letter;
      }
      $(".pagination").html(img);

      $.get(url, function(result) {
          $(".pagination").html($(".pagination", result).html());
          $("#pagination_table").html($("#pagination_table", result).html());
      });
      history.pushState(null, document.title, url);
  }

  function bindPopState(){

    // Bind it only once!
    if (once) {

       // let navigate the browser throught the ajax history
      $(window).bind("popstate", function (jEvent) {
        // Before run a quick check on the URL
        // If the user click on a link handled with JS that adds a # to the URL
        // This code here load the previous pagination state
        var previousURL = jEvent.originalEvent.state;
        // Check that the history change is due to the back button
        if(needToPaginate(previousURL, location.href)){
          $(".pagination").html(img);
          $.get(location.href, function(result) {
            $(".pagination").html($(".pagination", result).html());
              $("#pagination_table").html($("#pagination_table", result).html());
            });
        }
      });

    } else {
      once = true;
    }
  }

  function needToPaginate(prev, current){
    var regexp = /letter=[^&]*/;
    if((regexp).test(prev) && (regexp).test(current)){
      // same letter means don't paginate
      return prev.match(regexp)[0] !== current.match(regexp)[0];
    } else {
      // If only one of the two has a letter than paginate
      return (regexp).test(prev) || (regexp).test(current);
    }
  }


});

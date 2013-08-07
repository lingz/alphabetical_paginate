$(function() {
  var once = false;

  var img = "<img src='/assets/aloader.gif' class='loading'/>";
  // RAILS 3.0 USERS -> Please delete the above line and uncomment the bottom line
  //var img = "<img src='/images/aloader.gif' class='loading'/>";
  
  $(document).on("click", ".pagination#alpha a", function(e) {
      var url = location.href,
          letter = $(this).data("letter");
      if (/letter/.test(url)){
        url = url.replace(/letter=?.{1,3}/,"letter=" + letter);
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
      e.preventDefault();
  });


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

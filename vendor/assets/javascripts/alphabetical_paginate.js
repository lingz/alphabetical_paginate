$(function() {

    var img = "<img src='/images/aloader.gif' class='loading'/>"
    
    $(".pagination#alpha a").on("click", function(e) {
        var url = location.href,
            letter = $(this).data("letter");
        if (/letter/.test(url)){
          url = url.replace(/letter=?./,"letter=" + letter); 
        }
        else {
          if (/\?/.test(url)) {
            url += "&letter=" + letter
          }
          else {
            url += "?letter=" + letter 
          }
        }
        $('#pagination_table').load(url + " #pagination_table");
        jQuery(".pagination").html(img);
        history.pushState(null, document.title, url);
        e.preventDefault();
    });

    // Let navigate the browser throught the AJAX history
});

$(window).bind("popstate", function() {
      $('#pagination_table').load(location.href + " #pagination_table");
});
   


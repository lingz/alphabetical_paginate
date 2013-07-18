$(function() {
    var img = "<img src='/images/loader.gif' class='loading'/>"
    var text = "<span class='loading'>Page is loading...</span>"

    $(".pagination #alpha a").live("click", function(e) {
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
        console.log(url);
        jQuery.getScript(url);
        jQuery(".pagination").html(text+img);
        history.pushState(null, document.title, url);
        e.preventDefault();
    });

    // Let navigate the browser throught the AJAX history
    $(window).bind("popstate", function() {
        $.getScript(location.href);
        $(".pagination").html(text+img);
    });

});

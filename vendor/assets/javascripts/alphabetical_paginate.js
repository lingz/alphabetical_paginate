$(function() {
    var img = "<img src='/images/loader.gif' class='loading'/>"
    var text = "<span class='loading'>Page is loading...</span>"

    $(".pagination a").live("click", function(e) {
        //jQuery.setFragment({ "page" : jQuery.queryString(this.href).page })
        jQuery.getScript(this.href);
        jQuery(".pagination").html(text+img);
        history.pushState(null, document.title, this.href);
        e.preventDefault();
    });

    $(window).bind("popstate", function() {
        $.getScript(location.href);
        $(".pagination").html(text+img);
    });

});

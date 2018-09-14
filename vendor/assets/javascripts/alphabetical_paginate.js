$(document).load(
    function () {
        $(function() {

            var img = "<img src='/assets/aloader.gif' class='loading'/>";
            // // RAILS 3.0 USERS -> Please delete the above line and uncomment the bottom line
            // // ensure that the image directory matches
            // // var img = "<img src='/img/aloader.gif' class='loading'/>";
            //
            // var navbar = $(".pagination.alpha a");
            // // Pick the handler list: just a quick check for the jQuery version (see here: http://bugs.jquery.com/ticket/10589)
            // var handlers = navbar.data ? navbar.data('events') : jQuery._data(navbar[0], 'events');
            //
            // if (!handlers || -1 !== $.inArray(onNavbarClick, handlers.click)) {
            //     $(document).on("click", ".pagination.alpha a", onNavbarClick);
            //     if(hasHistory){
            //       // bind the popstate
            //       bindPopState(location.href);
            //     }
            // }

            // $(document).on('click', '[data-letter]', onNavbarClick);

            function onNavbarClick(e) {
                e.preventDefault();
                var url = location.href,
                    letter = $(this).data("letter");

                if( url.includes('&page')) {
                    url = url.replace(/&page=[^&]*/, "");
                }
                if (/letter/.test(url)) {
                    url = url.replace(/letter=[^&]*/, "letter=" + letter) + '&page=1';
                } else {
                    if (/\?/.test(url)) {
                        url += "&letter=" + letter + '&page=1';
                    } else {
                        url += "?letter=" + letter + '&page=1';
                    }
                }
                console.log(url);
                loadPage(url);

            }

            document.addEventListener("turbolinks:render", function() {
                $(document).on('click', '[data-letter]', onNavbarClick);
            });


            // let navigate the browser throught the ajax history
            function bindPopState(initialUrl){
                $(window).bind("popstate", function() {
                    var newUrl = location.href;
                    var diff = newUrl.replace(initialUrl, '');
                    // skip initial popstate
                    // skip anchor links (used for JS links)
                    if (diff !== '' && diff !== '#') {
                        loadPage(newUrl);
                    }
                });
            }

            function loadPage(url){
                $(".pagination").html(img);
                $.get(url, function (result) {
                    $(".pagination").html($(".pagination", result).html());
                    $("#pagination_table").html($("#pagination_table", result).html());
                });

            }


        });
    }
)

module AlphabeticalPaginate
  module ViewHelpers
    def alphabetical_paginate params, bootstrap=true
      output = javascript_include_tag 'alphabetical_paginate' 
      
      links = "\n"

      params[:availableLetters].each do |l|
        links += '<li><a href="#" data-letter="' + l + '">' + l + "</a></li>\n"
      end
      pagination = '<div class="pagination">\n' +
        "<ul>\n" +
        "%s" % links +
        "</ul\n" +
        "</div>"

      output += pagination.html_safe
    end
  end
end

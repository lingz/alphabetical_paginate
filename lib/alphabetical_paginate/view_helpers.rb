module AlphabeticalPaginate
  module ViewHelpers
    def alphabetical_paginate params

      output = javascript_include_tag 'alphabetical_paginate' 
      
      if params[:paginate_all]
        range = ('a'..'z').to_a
        if params[:others]
          range += ["#"]
        end
        if params[:enumerate] && params[:numbers]
          range = (0..9).to_a.map{|x| x.to_s} + range
        elsif params[:numbers]
          range = ["0"] + range
        end
        range.each.do |l|
          if l == params[:currentField]
            links += '<li class="active"><a href="#" data-letter="' + l + '">' + l + "</a></li>\n"
          elsif params[:availableLetters].contains? l
            links += '<li><a href="#" data-letter="' + l + '">' + l + "</a></li>\n"
          else
            links += '<li class="disabled"><a href="#" data-letter="' + l + '">' + l + "</a></li>\n"
          end
      else
        params[:availableLetters] -= (0..9).to_a.map{|x| x.to_s} if !params[:numbers]
        params[:availableLetters] -= ["#"] if !params[:others]
        
        params[:availableLetters].each do |l|
          if l == params[:currentField]
            links += '<li class="active"><a href="#" data-letter="' + l + '">' + l + "</a></li>\n"
          else
            links += '<li><a href="#" data-letter="' + l + '">' + l + "</a></li>\n"
          end
        end
      end
      

      if params[:pagination_class] != "none"
        pagination = '<div class="pagination %s">\n' % params[:pagination_class]
      else
        pagination = '<div class="pagination">\n'
      end
      pagination +=
        "<ul>\n" +
        "<li><a id='paginate-prev' href='#'>Prev</a></li>"
        "%s" % links +
        "</ul\n" +
        "<li><a id='paginate-next' href='#'>Next</a></li>" +
        "</div>"

      output += pagination.html_safe
    end
  end
end

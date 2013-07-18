module AlphabeticalPaginate
  module ViewHelpers
    def alphabetical_paginate params

      output = javascript_include_tag 'alphabetical_paginate' 
      links = ""
      
      if params[:paginate_all]
        range = ('a'..'z').to_a
        if params[:others]
          range += ["*"]
        end
        if params[:enumerate] && params[:numbers]
          range = (0..9).to_a.map{|x| x.to_s} + range
        elsif params[:numbers]
          range = ["0"] + range
        end
        range.each do |l|
          if l == params[:currentField]
            links += '<li class="active"><a href="#" data-letter="' + l + '">' + l + "</a></li>"
          elsif params[:availableLetters].include? l
            links += '<li><a href="#" data-letter="' + l + '">' + l + "</a></li>"
          else
            links += '<li class="disabled"><a href="#" data-letter="' + l + '">' + l + "</a></li>"
          end
        end
      else
        params[:availableLetters] -= (1..9).to_a.map{|x| x.to_s} if !params[:numbers]
        params[:availableLetters] -= ["*"] if !params[:others]
        
        params[:availableLetters].each do |l|
          if l == params[:currentField]
            links += '<li class="active"><a href="#" data-letter="' + l + '">' + l + "</a></li>"
          else
            links += '<li><a href="#" data-letter="' + l + '">' + l + "</a></li>"
          end
        end
      end
      

      if params[:pagination_class] != "none"
        pagination = '<div class="pagination %s" id="alpha">' % params[:pagination_class]
      else
        pagination = '<div class="pagination" id="alpha">'
      end
      pagination +=
        "<ul>" +
        "<li><a id='paginate-prev' href='#'>Prev</a></li>" +
        links +
        "<li><a id='paginate-next' href='#'>Next</a></li>" +
        "</ul" +
        "</div>"

      output += pagination.html_safe
    end
  end
end

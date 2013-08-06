module AlphabeticalPaginate
  module ViewHelpers
    def alphabetical_paginate params, options = { js: true }
      output = ""
      links = ""
      options[:js] = true unless options.has_key? :js

      output += javascript_include_tag 'alphabetical_paginate' if options[:js]
      
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
          elsif params[:db_mode] or params[:availableLetters].include? l
            links += '<li><a href="?letter=' + l + '" data-letter="' + l + '">' + l + "</a></li>"
          else
            links += '<li class="disabled"><a href="?letter=' + l + '" data-letter="' + l + '">' + l + "</a></li>"
          end
        end
      else
        params[:availableLetters].sort!
        params[:availableLetters] = params[:availableLetters][1..-1] + ["*"] if params[:availableLetters][0] == "*"
        params[:availableLetters] -= (1..9).to_a.map{|x| x.to_s} if !params[:numbers]
        params[:availableLetters] -= ["*"] if !params[:others]
        
        params[:availableLetters].each do |l|
          if l == params[:currentField]
            links += '<li class="active"><a href="#" data-letter="' + l + '">' + l + "</a></li>"
          else
            links += '<li><a href="?letter=' + l + '" data-letter="' + l + '">' + l + "</a></li>"
          end
        end
      end
      

      if params[:pagination_class] != "none"
        pagination = '<div class="pagination %s" id="alpha" style="height:35px;">' % params[:pagination_class]
      else
        pagination = '<div class="pagination" id="alpha" style="height:35px;">'
      end
      pagination +=
        "<ul>" +
        links +
        "</ul>" +
        "</div>"

      output += pagination
      output.html_safe
    end
  end
end

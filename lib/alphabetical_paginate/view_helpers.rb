# coding: utf-8
module AlphabeticalPaginate
  module ViewHelpers
    def alphabetical_paginate params
      output = ""
      links = ""

      output += javascript_include_tag 'alphabetical_paginate' if params[:js]
      
      if params[:paginate_all]
        range = params[:language].letters_range
        if params[:others]
          range += ["*"]
        end
        if params[:enumerate] && params[:numbers]
          range = (0..9).to_a.map{|x| x.to_s} + range
        elsif params[:numbers]
          range = ["0-9"] + range
        end
        range.unshift "All" if params[:include_all]
        range.each do |l|
          value = params[:language].output_letter(l)
          if l == params[:currentField]
            links += '<li class="active"><a href="#" data-letter="' + l + '">' + value + "</a></li>"
          elsif params[:db_mode] or params[:availableLetters].include? l
            links += '<li><a href="?letter=' + l + '" data-letter="' + l + '">' + value + "</a></li>"
          else
            links += '<li class="disabled"><a href="?letter=' + l + '" data-letter="' + l + '">' + value + "</a></li>"
          end
        end
      else
        params[:availableLetters].sort!
        params[:availableLetters] = params[:availableLetters][1..-1] + ["*"] if params[:availableLetters][0] == "*"
        params[:availableLetters].unshift "All" if params[:include_all]
        params[:availableLetters] -= (1..9).to_a.map{|x| x.to_s} if !params[:numbers]
        params[:availableLetters] -= ["*"] if !params[:others]
        
        params[:availableLetters].each do |l|
          value = params[:language].output_letter(l)
          if l == params[:currentField]
            links += '<li class="active"><a href="?letter=' + l + '" data-letter="' + l + '">' + value + '</a></li>'
          else
            links += '<li><a href="?letter=' + l + '" data-letter="' + l + '">' + value + "</a></li>"
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

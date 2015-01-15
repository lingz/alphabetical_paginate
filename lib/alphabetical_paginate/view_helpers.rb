# coding: utf-8
module AlphabeticalPaginate
  module ViewHelpers
    def alphabetical_paginate(options = {})
      output = ""
      links = ""
      output += javascript_include_tag 'alphabetical_paginate' if options[:js] == true
      options[:scope] ||= main_app
      
      if options[:paginate_all]
        range = options[:language].letters_range
        if options[:others]
          range += ["*"]
        end
        if options[:enumerate] && options[:numbers]
          range = (0..9).to_a.map{|x| x.to_s} + range
        elsif options[:numbers]
          range = ["0-9"] + range
        end
        range.unshift "All" if (options[:include_all] && !range.include?("All"))
        range.each do |l|
          
          url = options[:scope].url_for(options.merge(:letter => l))
          
          value = options[:language].output_letter(l)
          if l == options[:currentField]
            links += content_tag(:li, link_to(value, "#", "data-letter" => l), :class => "active")
          elsif options[:db_mode] or options[:availableLetters].include? l
            links += content_tag(:li, link_to(value, url, "data-letter" => l))
          else
            links += content_tag(:li, link_to(value, url, "data-letter" => l), :class => "disabled")
          end
        end
      else
        options[:availableLetters].sort!
        options[:availableLetters] = options[:availableLetters][1..-1] + ["*"] if options[:availableLetters][0] == "*"
        options[:availableLetters].unshift "All" if (options[:include_all] && !options[:availableLetters].include?("All"))
        options[:availableLetters] -= (1..9).to_a.map{|x| x.to_s} if !options[:numbers]
        options[:availableLetters] -= ["*"] if !options[:others]
        
        options[:availableLetters].each do |l|
          url = options[:scope].url_for(options.merge(:letter => l))
          value = options[:language].output_letter(l)
          links += content_tag(:li, link_to(value, url, "data-letter" => l), :class => ("active" if l == options[:currentField] ))
        end
      end
      

      element = options[:bootstrap3] ? 'ul' : 'div'
      if options[:pagination_class] != "none"
        pagination = "<#{element} class='pagination %s alpha' style='height:35px;'>" % options[:pagination_class]
      else
        pagination = "<#{element} class='pagination alpha' style='height:35px;'>"
      end
      pagination +=
        (options[:bootstrap3] ? "" : "<ul>") +
        links +
        (options[:bootstrap3] ? "" : "</ul>") +
        (options[:bootstrap3] ? "" : "</div>")

      output += pagination
      output.html_safe
    end
  end
end

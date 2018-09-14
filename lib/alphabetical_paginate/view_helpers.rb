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
          link_letter = l
          if options[:slugged_link] && (l =~ options[:language].letters_regexp || l == "All")
            link_letter = options[:language].slugged_letters[l]
          end
          letter_options = { letter: link_letter }
          if !options[:all_as_link] && (l == "All")
            letter_options[:letter] = nil
          end

          url = options[:scope].url_for(letter_options)
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
        options[:availableLetters].localize(:hr).sort!.to_a
        options[:availableLetters] = options[:availableLetters][1..-1] + ["*"] if options[:availableLetters][0] == "*"
        #Ensure that "All" is always at the front of the array
        if options[:include_all]
          options[:availableLetters].delete("All") if options[:availableLetters].include?("All")
          options[:availableLetters].unshift("All")
        end
        options[:availableLetters] -= (1..9).to_a.map{|x| x.to_s} if !options[:numbers]
        options[:availableLetters] -= ["*"] if !options[:others]

        options[:availableLetters].each do |l|
          link_letter = l
          if options[:slugged_link] && (l =~ options[:language].letters_regexp || l == "All")
            link_letter = options[:language].slugged_letters[l]
          end
          letter_options = { letter: link_letter }
          if !options[:all_as_link] && (l == "All")
            letter_options[:letter] = nil
          end

          url = options[:scope].url_for(letter_options)
          value = options[:language].output_letter(l)
          links += content_tag(:li, link_to(value, url, "data-letter" => l), :class => ("active" if l == options[:currentField] ))
        end
      end

      element = options[:bootstrap3] ? 'ul' : 'div'
      if options[:pagination_class] != "none"
        pagination = "<#{element} class='pagination %s alpha' >" % options[:pagination_class]
      else
        pagination = "<#{element} class='pagination alpha' >"
      end
      pagination +=
        (options[:bootstrap3] ? "" : "<ul>") +
        links +
        (options[:bootstrap3] ? "" : "</ul>") +
        "</#{element}>"

      output += pagination
      output.html_safe
    end
  end
end

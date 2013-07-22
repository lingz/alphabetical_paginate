class Array
  def alpha_paginate current_field, params = {enumerate:false, default_field: "a", 
                                                paginate_all: false, numbers: true,
                                                others: true, pagination_class: "pagination-centered"}
    params[:paginate_all] ||= false
    params[:numbers] = true if !params.has_key? :numbers
    params[:others] = true if !params.has_key? :numbers
    params[:pagination_class] ||= "pagination-centered"
    output = []
    availableLetters = {}
    if current_field == nil
      current_field = params[:default_field]
    end
    self.each do |x|
      field_val = block_given? ? yield(x).to_s : x.id.to_s
      field_letter = field_val[0].downcase
      case field_letter
        when /[a-z]/ 
          availableLetters[field_letter] = true if !availableLetters.has_key? field_letter
          output << x if current_field =~ /[a-z]/ && field_letter == current_field
        when /[0-9]/
          if params[:enumerate]
            availableLetters[field_letter] = true if !availableLetters.has_key? field_letter
            output << x if current_field =~ /[0-9]/ && field_letter == current_field 
          else
            availableLetters['0'] = true if !availableLetters.has_key? 'numbers'
            output << x if current_field == "0"
          end
        else
          availableLetters['*'] = true if !availableLetters.has_key? 'other'
          output << x if current_field == "*"
      end
    end
    params[:availableLetters] = availableLetters.collect{|k,v| k.to_s}
    params[:currentField] = current_field
    output.sort! {|x, y| yield(x).to_s <=> yield(y).to_s }
    return output, params
  end
end

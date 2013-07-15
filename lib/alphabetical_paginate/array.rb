class Array
  def alpha_paginate current_field, enumerate=false
    output = []
    params = {}
    availableLetters = {}
    if current_field == nil
      current_field = this.sort[0].to_s[0]
    end
    self.each do |x|
      field_val = block_given? ? yield(x) : x.id.to_s
      field_letter = field_val.force_encoding(Encoding::ASCII_8BIT)[0]
      case current_field
        when /[a-z]/ 
          availableLetters[field_letter] = true if !availableLetters.has_key? field_letter
          output << x if field_letter == current_field
        when "number"
          availableLetters['numbers'] = true if !availableLetters.has_key? 'numbers'
          output << x if field_letter =~ /[0-9]/
        when enumerate && /[0-9]/
          availableLetters[field_letter] = true if !availableLetters.has_key? field_letter
          output << x if field_letter == current_field
        when "other"
          availableLetters['other'] = true if !availableLetters.has_key? 'other'
          output << x if !field_letter =~ /[0-9a-z]/
      end
    end
    params[:availableLetters] = availableLetters.collect{|k,v| k.to_s}
    params[:currentField] = current_field
    params[:enumerate] = enumerate
    return output, params
  end
end

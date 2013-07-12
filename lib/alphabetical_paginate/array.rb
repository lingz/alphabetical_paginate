class Array
  def alpha_paginate current_field = "first"
    output = []
    field_val = block_given? ? yield(self) : self.id.to_s
    field_letter = field_val.force_encoding(Encoding::ASCII_8BIT)[0]
    if current_field == first
      current_field = this.sort[0].to_s[0]
    end
    case current_field
      when /[a-z]/ 
        self.each do |x|
          output << self if field_letter == current_field
        end
      when "number" 
        self.each do |x|
          output << self if field_letter =~ /[0-9]/
        end
      when "other"
        self.each do |x|
          output << self if !field_letter =~ /[0-9a-z]/
        end
    end
    output
  end
end

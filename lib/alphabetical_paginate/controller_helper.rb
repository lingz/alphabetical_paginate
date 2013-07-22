module AlphabeticalPaginate
  module ControllerHelpers
    extend ActiveSupport::Concern

    def alpha_paginate current_field, params = {enumerate:false, default_field: "a", 
                                                  paginate_all: false, numbers: true,
                                                  others: true, pagination_class: "pagination-centered",
                                                  batch_size: 500, db_mode: false, 
                                                  db_field: "id"}
      params[:paginate_all] ||= false
      params[:numbers] = true if !params.has_key? :numbers
      params[:others] = true if !params.has_key? :others
      params[:pagination_class] ||= "pagination-centered"
      params[:batch_size] ||= 500
      params[:default_field] ||= "a"
      params[:db_mode] ||= false
      params[:field] ||= "id"

      output = []

      if current_field == nil
        current_field = params[:default_field]
      end

      if params[:db_mode]
        if !ActiveRecord::Base.connection.adapter_name.downcase.include? "mysql"
          raise "You need a mysql database to ues db_mode with alphabetical_paginate"
        end
        params[:paginate_all] = true
        params[:availableLetters] = []

        case current_field[0].downcase
        when /[a-z]/
          output = self.where("%s REGEXP '^%s.*'" % [params[:db_field], current_field])
        when /[0-9]/
          if params[:enumerate]
            output = self.where("%s REGEXP '^%s.*'" % [params[:db_field], current_field])
          else
            output = self.where("%s REGEXP '^[0-9].*'" % [params[:db_field], current_field])
          end
        else
          output = self.where("%s REGEXP '^[^a-z0-9].*'" % [params[:db_field], current_field])
        end
        output.sort! {|x, y| x.send(params[:db_field]) <=> y.send(params[:db_field])}
      else
        availableLetters = {}
        self.find_each({batch_size: params[:batch_size]}) do |x|
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
        output.sort! {|x,y| yield(x).to_s <=> yield(y).to_s }
      end
      params[:currentField] = current_field
      return output, params
    end
  end
end

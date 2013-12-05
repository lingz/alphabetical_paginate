module AlphabeticalPaginate
  module ControllerHelpers
    def self.included(base)
      base.extend(self)
    end

    def alpha_paginate current_field, params = {enumerate:false, default_field: "a", 
                                                paginate_all: false, numbers: true,
                                                others: true, pagination_class: "pagination-centered",
                                                batch_size: 500, db_mode: false, 
                                                db_field: "id", include_all: true,
                                                js: true, support_language: :en,
                                                bootstrap3: false}
      params[:paginate_all] ||= false
      params[:support_language] ||= :en
      params[:language] = AlphabeticalPaginate::Language.new(params[:support_language])
      params[:include_all] = true if !params.has_key? :include_all
      params[:numbers] = true if !params.has_key? :numbers
      params[:others] = true if !params.has_key? :others
      params[:js] = true if !params.has_key? :js
      params[:pagination_class] ||= "pagination-centered"
      params[:batch_size] ||= 500
      params[:default_field] ||= params[:include_all] ? "all" : params[:language].default_letter
      params[:db_mode] ||= false
      params[:db_field] ||= "id"

      output = []

      if current_field == nil
        current_field = params[:default_field]
      end
      current_field = current_field.mb_chars.downcase.to_s
      all = params[:include_all] && current_field == "all"

      if params[:db_mode]
        if !ActiveRecord::Base.connection.adapter_name.downcase.include? "mysql"
          raise "You need a mysql database to use db_mode with alphabetical_paginate"
        end
        params[:paginate_all] = true
        params[:availableLetters] = []

        if all
          output = self
        else
          case current_field
          when params[:language].letters_regexp
            output = self.where("LOWER(%s) REGEXP '^%s.*'" % [params[:db_field], current_field])
          when /[0-9]/
            if params[:enumerate]
              output = self.where("LOWER(%s) REGEXP '^%s.*'" % [params[:db_field], current_field])
            else
              output = self.where("LOWER(%s) REGEXP '^[0-9].*'" % [params[:db_field], current_field])
            end
          else
            output = self.where("LOWER(%s) REGEXP '^[^a-z0-9].*'" % [params[:db_field], current_field])
          end
        end
        #output.sort! {|x, y| x.send(params[:db_field]) <=> y.send(params[:db_field])}
        output.order("#{params[:db_field]} ASC")
      else
        availableLetters = {}
        self.find_each({batch_size: params[:batch_size]}) do |x|
          field_val = block_given? ? yield(x).to_s : x.id.to_s
          field_letter = field_val[0].mb_chars.downcase.to_s
          case field_letter
            when params[:language].letters_regexp
              availableLetters[field_letter] = true if !availableLetters.has_key? field_letter
              output << x if all || (current_field =~ params[:language].letters_regexp && field_letter == current_field)
            when /[0-9]/
              if params[:enumerate]
                availableLetters[field_letter] = true if !availableLetters.has_key? field_letter
                output << x if all || (current_field =~ /[0-9]/ && field_letter == current_field) 
              else
                availableLetters['0-9'] = true if !availableLetters.has_key? 'numbers'
                output << x if all || current_field == "0-9"
              end
            else
              availableLetters['*'] = true if !availableLetters.has_key? 'other'
              output << x if all || current_field == "*"
          end
        end
        params[:availableLetters] = availableLetters.collect{ |k,v| k.mb_chars.capitalize.to_s }
        output.sort! {|x, y| block_given? ? (yield(x).to_s <=> yield(y).to_s) : (x.id.to_s <=> y.id.to_s) }
      end
      params[:currentField] = current_field.mb_chars.capitalize.to_s
      return output, params
    end
  end
end

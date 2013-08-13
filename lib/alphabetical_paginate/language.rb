# coding: utf-8
module AlphabeticalPaginate
  class Language
    attr_reader :code

    def initialize(code)
      @code = code
    end

    def russian?
      defined?(I18n) && I18n.locale == :ru && code == :ru
    end

    def letters_regexp
      russian? ? /[#{russian_letters}]/ : /[a-z]/
    end

    def letters_range
      if russian?
        letters = []
        russian_letters.each_char{ |x| letters << x }
        letters
      else
        ('a'..'z').to_a
      end
    end

    def output_letter(l)
      (l == "all") ? all_field : l
    end

    def all_field
      russian? ? 'все' : "all"
    end

    def default_letter
      russian? ? "а" : "a" # First 'a' is russian, second - english
    end

    private
      def russian_letters
        "абвгдежзиклмнопрстуфхцчшэюя"
      end
  end
end

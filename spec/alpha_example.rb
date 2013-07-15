module AlphabeticalPaginate
  class AlphaExample
    attr_accessor :id, :word

    def initialize(letter)
      @id = letter
      @word = letter.reverse
    end

    def to_s
      "{%s, %s}" % [@id, @word]
    end

  end
end

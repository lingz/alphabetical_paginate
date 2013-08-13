# coding: utf-8

module AlphabeticalPaginate
  describe Language do
    context "English language" do
      before(:all) do
        @language = AlphabeticalPaginate::Language.new(:en)
      end

      it "should return false on russian? method" do
        @language.russian?.should be_false
      end

      it "should return /[a-z]/ regexp" do
        @language.letters_regexp.should eq(/[a-z]/)
      end

      it "should return array of english letters" do
        @language.letters_range.should eq(("a".."z").to_a)
      end

      it "should return english representation of 'all' field and other english letters (for view helper)" do
        (["all"] + ("a".."z").to_a).map do |l|
          @language.output_letter(l).should eq(l)
        end
      end

      it "should return english representation of 'a' letter" do
        @language.default_letter.should eq("a")
      end
    end

    context "Russian language" do
      before(:all) do
        @language = AlphabeticalPaginate::Language.new(:ru)
        @russian_string = "абвгдежзиклмнопрстуфхцчшэюя"
        @russian_array = []
        @russian_string.each_char{ |x| @russian_array << x }
      end

      it "should return true on russian? method" do
        @language.russian?.should be_true
      end

      it "should return /[абвгдежзиклмнопрстуфхцчшэюя]/ regexp" do
        @language.letters_regexp.should eq(/[#{@russian_string}]/)
      end

      it "should return array of russian letters" do
        @language.letters_range.should eq(@russian_array)
      end

      it "should return russian representation of 'all' field and other russian letters (for view helper)" do
        (["все"] + @russian_array).map do |l|
          @language.output_letter(l).should eq(l)
        end
      end

      it "should return russian representation of 'a' letter" do
        @language.default_letter.should eq("а")
      end
    end
  end
end

# coding: utf-8
require 'alphabetical_paginate'

module AlphabeticalPaginate
  describe Language do

    context "English language" do
      before(:all) do
        I18n.locale = :en
        @language = AlphabeticalPaginate::Language.new(I18n.locale)
      end

      it "should return false on russian? method" do
        @language.russian?.should be_false
      end

      it "should return /[a-zA-Z]/ regexp" do
        @language.letters_regexp.should eq(/[a-zA-Z]/)
      end

      it "should return array of english letters" do
        @language.letters_range.should eq(("A".."Z").to_a)
      end

      it "should return english representation of 'All' field and other english letters (for view helper)" do
        (["All"] + ("A".."Z").to_a).map do |l|
          @language.output_letter(l).should eq(l)
        end
      end

      it "should return english representation of 'a' letter" do
        @language.default_letter.should eq("a")
      end
    end

    context "Russian language" do
      before(:all) do
        I18n.locale = :ru
        @language = AlphabeticalPaginate::Language.new(I18n.locale)
        @russian_string = "АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЭЮЯ"
        @russian_array = []
        @russian_string.each_char{ |x| @russian_array << x }
      end

      it "should return true on russian? method" do
        @language.russian?.should be_true
      end

      it "should return /[а-яА-Я]/ regexp" do
        @language.letters_regexp.should eq(/[а-яА-Я]/)
      end

      it "should return array of russian letters" do
        @language.letters_range.should eq(@russian_array)
      end

      it "should return russian representation of 'All' field and other russian letters (for view helper)" do
        (["Все"] + @russian_array).map do |l|
          @language.output_letter(l).should eq(l)
        end
      end

      it "should return russian representation of 'а' letter" do
        @language.default_letter.should eq("а")
      end
    end
  end
end

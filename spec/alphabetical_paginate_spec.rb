# coding: utf-8
require 'alpha_example'
require 'alphabetical_paginate'
require_relative '#{File.dirname(__FILE__)}/../../lib/alphabetical_paginate/view_helpers'

# stub methods
def javascript_include_tag x
	return ""
end
class String
	def html_safe
		return self
	end
end

class RouterMock
  def url_for(options)
    '?letter='+options[:letter]
  end
end

def main_app
  RouterMock.new()
end

def link_to(value, url, options)
  "<a href='#{url}' data-letter=\"#{options["data-letter"]}\">#{value}</a>"
end

def content_tag(type, el, html_options={})
  "<#{type.to_s} class='#{html_options[:class] || ''}'>#{el}</#{type.to_s}>"
end


module AlphabeticalPaginate

  describe AlphabeticalPaginate do

    describe "#alpha_paginate" do
      before :each do
        @list = ["aa", "ab", "ac",
          "ba", "bb", "bg",
          "ca", "cd", "ce"].map do |x|
          AlphaExample.new(x)
        end
      end

      it "should paginate by id automatically" do
        expectedCollection = ["ba", "bb", "bg"].map do |x|
          AlphaExample.new(x)
        end
        expectedParams = {
          availableLetters: ["a", "b", "c"],
          currentField: "b",
          enumerate: false,
        }
        collection, params = @list.alpha_paginate("b")
        collection.to_s.should == 
          expectedCollection.to_s
        params.to_s.should include
          expectedParams.to_s
      end

      it "should paginate by block when needed" do
        expectedCollection = ["ab", "bb"].map do |x|
          AlphaExample.new(x)
        end
        expectedParams = {
          availableLetters: ["a", "b", "c", "g", "d", "e"],
          currentField: "b",
          enumerate: false,
        }
        collection, params = @list.alpha_paginate("b") do |x|
          x.word
        end
        collection.to_s.should == 
          expectedCollection.to_s
        params.to_s.should include
          expectedParams.to_s
      end
    end

    describe "#alpha_paginate in russian characters" do
      before :each do
        I18n.locale = :ru
        @list = ["аа", "аб", "ас",
          "ба", "бб", "бв",
          "са", "сд", "се"].map do |x|
          AlphaExample.new(x)
        end
      end

      it "should paginate by id automatically" do
        expectedCollection = ["са", "сд", "се"].map do |x|
          AlphaExample.new(x)
        end
        expectedParams = {
          availableLetters: ["а", "б", "с"],
          currentField: "с",
          enumerate: false,
        }
        collection, params = @list.alpha_paginate("с", { support_language: :ru })
        collection.to_s.should == 
          expectedCollection.to_s
        params.to_s.should include
          expectedParams.to_s
      end

      it "should paginate for russian characters with default 'a' character" do
        expectedCollection = ["аа", "аб", "ас"].map do |x|
          AlphaExample.new(x)
        end
        expectedParams = {
          availableLetters: ["а", "б", "с"],
          currentField: "а",
          enumerate: false,
        }
        collection, params = @list.alpha_paginate(nil, { include_all: false, support_language: :ru })
        collection.to_s.should == 
          expectedCollection.to_s
        params.to_s.should include
          expectedParams.to_s
      end
    end

    include ViewHelpers

    describe "#alphabetical_paginate" do
      before :each do
        @list = []
        (["@!#"] + (0..9).to_a.map{|x| x.to_s} + ("A".."Z").to_a).each do |x|
          ("A".."Y").to_a.each do |y|
            @list << x + y
          end
        end
        @list.map! do |x|
          AlphaExample.new(x)
        end
      end

      it "should have div tags and pagination classes" do
        index, params = @list.alpha_paginate(nil)
        pagination = alphabetical_paginate(params)
        pagination.should include "div", "pagination"
      end

      it "should include a numbers and others field" do
        index, params = @list.alpha_paginate(nil)
        pagination = alphabetical_paginate(params)
        (["*"] + ["0-9"] + ("A".."Z").to_a.map{|x|
          'data-letter="%s"'%x}).each do |x|
          pagination.should include x
        end
      end

      it "should default all values when necessary" do
        index, params = @list.alpha_paginate(nil, {})
        pagination = alphabetical_paginate(params)
        (["*"] + ["0-9"] + ("A".."Z").to_a.map{|x|
          'data-letter="%s"'%x}).each do |x|
          pagination.should include x
        end
      end

      it "should hide values that don't exist" do
        index, params = @list.alpha_paginate(nil){|x| x.word}
        pagination = alphabetical_paginate(params)
        (("A".."Y").to_a.map{|x|
          'data-letter="%s"'%x}).each do |x|
          pagination.should include x
        end
        pagination.should_not include 'data-letter="Z"', 'data-letter="*"',
          'data-letter="0-9"'
      end

      it "should enumerate when asked" do
        index, params = @list.alpha_paginate(nil, {enumerate: true})
        pagination = alphabetical_paginate(params)
        (("0".."9").to_a.map{|x|
          'data-letter="%s"'% x.to_s }).each do |x|
          pagination.should include x
        end

      end

      it "should display all when asked" do
        index, params = @list.alpha_paginate(nil, {paginate_all: true,
                                             enumerate: true}){|x| x.word}
        pagination = alphabetical_paginate(params)
        (["*"] + (0..9).to_a.map{|x| x.to_s} + ("A".."Z").to_a.map{|x|
          'data-letter="%s"'%x}).each do |x|
          pagination.should include x
        end
      end

      it "should include 'all' and '0-9' fields" do
        index, params = @list.alpha_paginate(nil, { include_all: true })
        pagination = alphabetical_paginate(params)
        (["All", "0-9"].map{|x|
          'data-letter="%s"'%x}).each do |x|
          pagination.should include x
        end
      end
    end

    describe "#alphabetical_paginate in russian characters" do
      before :each do
        @list = []
        ("А".."Я").to_a.each do |x|
          ("А".."Т").to_a.each do |y|
            @list << x + y
          end
        end
        @list.map! do |x|
          AlphaExample.new(x)
        end
        @russian_array = []
        "АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЭЮЯ".each_char{ |x| @russian_array << x }
      end

      it "should display russian characters through additional attribute(language)" do
        I18n.locale = :ru
        index, params = @list.alpha_paginate(nil, { paginate_all: true, others: false, support_language: :ru }){|x| x.word}
        pagination = alphabetical_paginate(params)
        (["0"] + @russian_array.map{|x|
          'data-letter="%s"'%x}).each do |x|
          pagination.should include x
        end
      end
    end
  end
end

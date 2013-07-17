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
    include ViewHelpers

      describe "#alphabetical_paginate" do
        before :each do
          @list = []
          (["@!#"] + (0..9).to_a.map{|x| x.to_s} + ("a".."z").to_a).each do |x|
            ("a".."y").to_a.each do |y|
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
					(["#"] + ["0"] + ("a".."z").to_a.map{|x|
						'data-letter="%s"'%x}).each do |x|
						pagination.should include x
					end
				end

				it "should default all values when necessary" do
					index, params = @list.alpha_paginate(nil, {})
					pagination = alphabetical_paginate(params)
					(["#"] + ["0"] + ("a".."z").to_a.map{|x|
						'data-letter="%s"'%x}).each do |x|
						pagination.should include x
					end
				end

				it "should hide values that don't exist" do
					index, params = @list.alpha_paginate(nil){|x| x.word}
					pagination = alphabetical_paginate(params)
					(("a".."y").to_a.map{|x|
						'data-letter="%s"'%x}).each do |x|
						pagination.should include x
					end
					pagination.should_not include 'data-letter="z"', 'data-letter="#"',
						'data-letter="0"'
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
					(["#"] + (0..9).to_a.map{|x| x.to_s} + ("a".."z").to_a.map{|x|
						'data-letter="%s"'%x}).each do |x|
						pagination.should include x
					end
				end



      end
    end

end

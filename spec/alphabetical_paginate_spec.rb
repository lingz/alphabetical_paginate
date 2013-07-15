require 'alpha_example'
require 'alphabetical_paginate'

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
        params.to_s.should ==
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
        params.to_s.should ==
          expectedParams.to_s
      end
    end

  end
end

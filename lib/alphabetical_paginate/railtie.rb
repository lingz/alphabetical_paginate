require 'alphabetical_paginate/view_helpers'
module AlphabeticalPaginate
  class Railtie < Rails::Railtie
    initializer "alphabetical_paginate.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end

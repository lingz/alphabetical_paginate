require 'alphabetical_paginate/view_helpers'
require 'alphabetical_paginate/controller_helper'
module AlphabeticalPaginate
  class Railtie < Rails::Railtie
    initializer "alphabetical_paginate.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
    initializer "alphabetical_paginate.controller_helpers" do
      ActiveRecord::Relation.send :include, ControllerHelpers
      ActiveRecord::Base.send :include, ControllerHelpers
    end
  end
end

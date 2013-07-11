require "alphabetical_paginate/version"

module AlphabeticalPaginate
  # Your code goes here...
  class Engine < Rails::Engine
    initializer 'static_assets.load_static_assets' do |app|
        app.middleware.use ::ActionDispatch::Static, "#{root}/vendor"
    end
  end
end

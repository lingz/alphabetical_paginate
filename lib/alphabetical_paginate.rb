require "alphabetical_paginate/version"
require "alphabetical_paginate/array"
require "alphabetical_paginate/language"
require "alphabetical_paginate/railtie" if defined?(Rails)

module AlphabeticalPaginate
  require 'alphabetical_paginate/engine'
end

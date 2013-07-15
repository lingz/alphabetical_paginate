module AlphabeticalPaginate
  module ViewHelpers
    def alphabetical_paginate
      output = javascript_include_tag 'alphabetical_paginate' + " \n"
    end
  end
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alphabetical_paginate/version'

Gem::Specification.new do |spec|
  spec.name          = "alphabetical_paginate"
  spec.version       = AlphabeticalPaginate::VERSION
  spec.authors       = ["lingz"]
  spec.email         = ["lz781@nyu.edu"]
  spec.description   = "Alphabetical Pagination"
  spec.summary       = "Pagination"
  spec.homepage      = "https://github.com/lingz/alphabetical_paginate"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.6"
  spec.add_development_dependency "rails"
end

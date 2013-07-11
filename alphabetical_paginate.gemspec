# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alphabetical_paginate/version'

Gem::Specification.new do |spec|
  spec.name          = "alphabetical_paginate"
  spec.version       = "0.1.0"
  spec.authors       = ["lingz"]
  spec.email         = ["lz781@nyu.edu"]
  spec.description   = "Alphabetical Pagination"
  spec.summary       = "Pagination"
  spec.homepage      = "http:google.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

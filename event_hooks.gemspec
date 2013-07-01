# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'event_hooks/version'

Gem::Specification.new do |gem|
  gem.name          = "event_hooks"
  gem.version       = EventHooks::VERSION
  gem.authors       = ["pcrwebdesign"]
  gem.email         = ["pablo@pcr-webdesign.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

	gem.add_development_dependency "rspec", "~>2.12"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end

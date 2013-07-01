# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'event_hooks/version'

Gem::Specification.new do |gem|
  gem.name          = "event_hooks"
  gem.version       = EventHooks::VERSION
  gem.authors       = ["Pablo Calderon"]
  gem.email         = ["pablo@pcr-webdesign.com"]
  gem.description   = %q{Add hooks before or after events}
  gem.summary       = %q{HookEvents allows you to add pre and post-conditions to events}
  gem.homepage      = ""

	gem.add_development_dependency "rspec", "~> 2.12.0"
	gem.add_development_dependency "activerecord"
	gem.add_development_dependency "sqlite3"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end

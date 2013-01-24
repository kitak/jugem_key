# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jugem_key/version'

Gem::Specification.new do |gem|
  gem.name          = "jugem_key"
  gem.version       = JugemKey::VERSION
  gem.authors       = ["Keisuke KITA"]
  gem.email         = ["kei.kita2501@gmail.com"]
  gem.description   = %q{A simple interface for using the JugenKey Auththentication API.}
  gem.summary       = %q{using the JugemKey auth}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'feed-normalizer'
  gem.add_development_dependency 'sinatra'
end

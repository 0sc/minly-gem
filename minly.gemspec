# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minly/version'

Gem::Specification.new do |spec|
  spec.name          = "minly"
  spec.version       = Minly::VERSION
  spec.authors       = ["Osmond Oscar"]
  spec.email         = ["oskarromero3@gmail.com"]

  spec.summary       = %q{Gem to wrap minly url shortener api}
  spec.homepage      = "http://github.com/andela-ooranagwa/minly/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest",  "~> 5.8", ">= 5.8.0"
  spec.add_development_dependency "vcr", "~> 2.9", ">= 2.9.3"
  spec.add_development_dependency "webmock", "~> 1.22", ">= 1.22.1"
  spec.add_development_dependency "simplecov", "~> 0.10.0"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4.8"
  spec.add_development_dependency "pry", "~>0.10.3"

  spec.add_dependency "faraday", "~> 0.9", ">= 0.9.2"
  spec.add_dependency "json", "~> 1.8", ">= 1.8.3"
end

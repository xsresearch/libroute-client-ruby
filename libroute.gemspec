# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'libroute/version'

Gem::Specification.new do |spec|
  spec.name          = "libroute"
  spec.version       = Libroute::VERSION
  spec.authors       = ["David Lisk (XS Research Ltd)"]
  spec.email         = ["david.lisk@xsresearch.co.uk"]

  spec.summary       = %q{Libroute standardises and simplifies the process of running third party libraries}
  spec.homepage      = "http://libroute.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "docker-api", "~> 1.31"
  spec.add_runtime_dependency "bson", "~> 4.1"  

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end

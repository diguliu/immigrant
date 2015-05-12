# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emigrant/version'

Gem::Specification.new do |spec|
  spec.name          = "emigrant"
  spec.version       = Emigrant::VERSION
  spec.authors       = ["Rodrigo Souto"]
  spec.email         = ["rodrigo@colivre.coop.br"]
  spec.summary        = %q{Emigrant is a framework to assist on external database migrations into a Rails app using AR as interface.}
  spec.description = <<-EOF
    This lib works as a fail-safe progress aware white-box framework to assist
    external database migrations into a Rails app. The framework provides
    specific infra-structure to allow the developer to create only the ActiveRecord
    interfaces with the proper migration implementation to migrate the external
    entities into your Rails app.
  EOF
  spec.homepage      = ""
  spec.license       = "GPL-3.0+"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency 'progressbar', '~> 0.21'
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruson/version'

Gem::Specification.new do |spec|
  spec.name    = 'ruson'
  spec.version = Ruson::VERSION
  spec.authors = ['klriutsa']
  spec.email   = ['kurushima.hiroya@gmail.com']

  spec.summary     = %q{A Ruby serialization/deserialization library to convert Ruby Objects into JSON and back}
  spec.description = %q{A Ruby serialization/deserialization library to convert Ruby Objects into JSON and back}
  spec.homepage    = 'https://github.com/klriutsa/ruson'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 2.5'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'ffaker', '~> 2.13.0'
  spec.add_development_dependency 'rake', '>= 12.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'timecop', '~> 0.9.1'
end

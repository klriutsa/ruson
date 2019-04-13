# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ruson/version"

Gem::Specification.new do |spec|
  spec.name    = "ruson"
  spec.version = Ruson::VERSION
  spec.authors = ["klriutsa"]
  spec.email   = ["hiroya.kurushima@litalico.co.jp"]

  spec.summary     = %q{ruby json library.}
  spec.description = %q{ruby json library.}
  spec.homepage    = "https://github.com/klriutsa/ruson"
  spec.license     = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'activesupport'
end

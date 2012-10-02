# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "setsumei/version"

Gem::Specification.new do |s|
  s.name        = "setsumei"
  s.version     = Setsumei::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Rowe"]
  s.email       = ["hello@jonrowe.co.uk"]
  s.homepage    = "https://github.com/JonRowe/setsumei"
  s.summary     = %q{A tool for describing API's as ruby objects}
  s.description = %q{A tool for describing API's as ruby objects. Currently supports building these objects from JSON}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency     'json'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'autotest-standalone'
end

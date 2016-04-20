# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hockeybrake/version"

Gem::Specification.new do |s|
  s.name        = "hockeybrake"
  s.version     = HockeyBrake::VERSION
  s.authors     = ["Dirk Eisenberg"]
  s.email       = ["dirk.eisenberg@gmail.com"]
  s.homepage    = 'http://rubygems.org/gems/hockeybrake'
  s.summary     = %q{An extension for the amazing airbrake gem which routes crash reports to HockeyApp}
  s.description = %q{An extension for the amazing airbrake gem which routes crash reports directly to HockeyApp}
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<airbrake>, ["~> 5.2"])
  s.add_runtime_dependency(%q<multipart-post>, ['~> 2.0'])
  s.add_runtime_dependency(%q<activesupport>, ['~> 4.2'])
end

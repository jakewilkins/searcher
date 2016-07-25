# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "crags/version"

Gem::Specification.new do |s|
  s.name        = "crags"
  s.version     = Crags::VERSION
  s.authors     = ["Justin Marney"]
  s.email       = ["gotascii@gmail.com"]
  s.homepage = "http://github.com/gotascii/crags"
  s.summary = "A library to help search across multiple craigslist locations."
  s.description = "A library to help search across multiple craigslist locations."
  s.rubyforge_project = "crags"
  s.files         = Dir["#{`pwd`.chomp}/crags/lib/*.rb"]+Dir["#{`pwd`.chomp}/crags/lib/**/*.rb"]
  s.require_paths = ["lib"]
  s.add_runtime_dependency("nokogiri", "~> 1.6.4")
  s.add_runtime_dependency("patron", ">= 0")
  s.add_development_dependency("rake", "~> 0.9.2")
  s.add_development_dependency("rdoc")
  s.add_development_dependency("rspec", "~> 2.4")
end

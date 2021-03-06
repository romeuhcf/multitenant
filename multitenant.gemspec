$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "multitenant/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "multitenant"
  s.version     = Multitenant::VERSION
  s.authors     = ["Romeu Fonseca"]
  s.email       = ["romeu.hcf@gmail.com"]
  s.homepage    = "https://github.com/romeuhcf/multitenant"
  s.summary     = "Set of utilities to rails work as a multi-tenant system."
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.1.0"

  s.add_development_dependency "mysql2"
end

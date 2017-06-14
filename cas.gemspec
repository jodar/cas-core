$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cas/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cas"
  s.version     = Cas::VERSION
  s.authors     = ["Thayná de Oliveira"]
  s.email       = ["euthaynaeng@gmail.com"]
  s.homepage    = ""
  s.summary     = "Summary of Cas."
  s.description = "Description of Cas."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 5.0.1"
  s.add_dependency "pg"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "poltergeist"
  s.add_development_dependency "capybara"
  s.add_development_dependency "pry-rails"

end
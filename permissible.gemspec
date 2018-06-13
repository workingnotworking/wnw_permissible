$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "permissible/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "permissible"
  s.version     = Permissible::VERSION
  s.authors     = ["Rob Cameron"]
  s.email       = ["rob.cameron@workingnotworking.com"]
  s.homepage    = "https://github.com/workingnotworking/permissible"
  s.summary     = "Adds role-based permissions to a Rails application"
  s.description = "Adds role-based permissions to a Rails application"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0"

  s.add_development_dependency "sqlite3"
end

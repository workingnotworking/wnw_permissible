$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "wnw_permissible/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wnw_permissible"
  s.version     = WnwPermissible::VERSION
  s.authors     = ["Rob Cameron"]
  s.email       = ["rob@workingnotworking.com"]
  s.homepage    = "https://github.com/workingnotworking/wnw_permissible"
  s.summary     = "Adds role-based permissions to a Rails application"
  s.description = "Include as a concern in your User model"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0"

  s.add_development_dependency "sqlite3", "~> 1.3"
end

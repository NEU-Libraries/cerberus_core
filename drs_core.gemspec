$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "drs_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "drs_core"
  s.version     = DrsCore::VERSION
  s.authors     = ["Will Jackson"]
  s.email       = ["wjackson64@gmail.com"]
  s.homepage    = "http://github.com/NEU-Libraries/"
  s.summary     = "Core architectural components of a fedora repository built in the DRS repository."
  s.description = "What it says on the tin"

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "hydra-head", "6.3.3"
  s.add_dependency "hydra-derivatives", "0.0.8"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "jettywrapper"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]
end

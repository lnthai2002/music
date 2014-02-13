$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "music/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "music"
  s.version     = Music::VERSION
  s.authors     = ["Nhut Thai Le"]
  s.email       = ["lnthai2002@yahoo.com"]
  s.homepage    = "http://darkportal.no-ip.info/pas/music"
  s.summary     = "Manage digital song tags"
  s.description = "Web interface to tag editor"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.1"
  s.add_dependency 'rubycas-client'       #integrate with single-sign-on service
  s.add_dependency 'taglib-ruby'
  s.add_dependency 'activerecord-tableless'
  s.add_dependency 'foundation-rails'     #foundation UI framework
  s.add_dependency 'cancan'

  s.add_dependency 'mysql2'
  s.add_dependency 'haml-rails'           #shorter syntax to code layout
  s.add_dependency 'dynamic_form'         #easy to render form error
  s.add_dependency 'jquery-rails'
  s.add_dependency 'remotipart'
  
  s.add_development_dependency 'rails_layout' #generate template for foundation/bootstrap
end

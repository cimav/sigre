# encoding: UTF-8

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "vinculacion/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "vinculacion"
  s.version     = Vinculacion::VERSION
  s.authors     = ["Jonathan Hernández"]
  s.email       = ["ion@cimav.edu.mx"]
  s.homepage    = "http://github.com/cimav/sigre"
  s.summary     = "Módulo de Vinculación (Ventas)"
  s.description = s.summary

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"
  s.add_dependency 'active_model_serializers'
  s.add_dependency 'ember-rails', '~>0.15'
  s.add_dependency 'ember-source', '1.4'
  s.add_dependency 'ember-data-source', '1.0.0.beta.5'
  s.add_dependency 'select2-rails', '~>3.5.4'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'haml'
  s.add_dependency 'resque-bus'
  s.add_dependency 'carrierwave'
  s.add_dependency 'spreadsheet'
  s.add_development_dependency "mysql2"
end

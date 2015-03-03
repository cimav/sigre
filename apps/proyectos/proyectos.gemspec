# encoding: UTF-8

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "proyectos/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "proyectos"
  s.version     = Proyectos::VERSION
  s.authors     = ["Juan Calderón"]
  s.email       = ["juan.calderon@cimav.edu.mx"]
  s.homepage    = "http://github.com/cimav/sigre"
  s.summary     = "Módulo de Administración de Proyectos."
  s.description = s.summary

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.3"

  s.add_dependency 'active_model_serializers'
  s.add_dependency 'ember-rails', '~>0.15'
  s.add_dependency 'ember-source', '1.4'
  s.add_dependency 'ember-data-source', '1.0.0.beta.5'
  s.add_dependency 'select2-rails', '~>3.5.4'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'haml'

  s.add_development_dependency "mysql2"
end



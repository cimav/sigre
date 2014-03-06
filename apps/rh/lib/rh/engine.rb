module Rh
  class Engine < ::Rails::Engine
    isolate_namespace Rh
    config.autoload_paths += [File.join(self.root, %w[lib])]
    require 'haml'
    require 'jquery-rails'
    require 'ember-rails'
    require 'select2-rails'
  end
end

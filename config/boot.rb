# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
ENV['NLS_LANG'] = 'SPANISH_SPAIN.UTF8'

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

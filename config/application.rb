require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
#Bundler.require(*Rails.groups(:assets => %w(development test))) if defined?(Bundler)


module Sigre
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Chihuahua'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :es

    # Email Configuration
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address   => "smtp.gmail.com",
      :port      => 587,
      :domain    => "cimav.edu.mx",
      :authentication => :plain,
      :user_name      => "servicio.cliente@cimav.edu.mx",
      :password       => "S1gr3@2016",
      :enable_starttls_auto => true
    }

    config.secret_key_base = 'blipblapblup'
  end
end

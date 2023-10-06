require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Legsim
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    
    # we don't go in for any of that fancy cloud storage here, no thank you
    config.active_storage.service = :local

    config.active_record.legacy_connection_handling = false

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'legsim.org',
      user_name:            Rails.application.credentials.gmail[:user_name],
      password:             Rails.application.credentials.gmail[:password],
      authentication:       'plain',
      enable_starttls_auto: true 
    }       
  end
end

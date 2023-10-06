source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.4'
# Use mysql as the database for Active Record
gem 'mysql2', '0.5.3'
# Use Puma as the app server
gem 'puma', '6.0.2'
# Use SCSS for stylesheets
# gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem "sprockets-rails"

gem 'devise'
gem 'activemerchant'
gem 'american_date'
# gem 'sidekiq-scheduler', branch: 'v5.0.0.beta2'
gem "sidekiq-scheduler", github: "sidekiq-scheduler/sidekiq-scheduler", branch: "v5.0.0.beta2"
gem 'image_processing'
gem 'active_storage_validations'
gem 'csv'
gem 'mail'
gem 'net-smtp', require: false

gem 'sentry-raven'
gem 'rexml'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri

  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'

  gem 'capistrano', "~> 3.10", require: false
  gem 'capistrano-rails', "~> 1.4", require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano3-puma', require: false
#  gem 'capistrano3-puma', github: "seuros/capistrano-puma"
  gem 'capistrano-bundler', '~> 1.6', require: false
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano-sidekiq'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'spring', '>= 3.0.0'
  #gem 'spring-watcher-listen'
  gem "bcrypt_pbkdf", require: false
  gem "ed25519", require: false

end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

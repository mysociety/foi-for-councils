# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 8.1.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Hackney theme
gem 'govuk_elements_form_builder'
gem 'hackney_template', path: 'gems/hackney_template-0.0.2'

# Case management
gem 'icasework'
gem 'infreemation'

# Background workers
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-scheduler'

# Error reporting
gem 'exception_notification'

gem 'omniauth', '~> 2.4.2'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

gem 'scenic'

gem 'csv'
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'factory_bot_rails', '~> 6.2'
  # Use Puma as the app server, also for JavaScript system specs
  gem 'puma', '~> 5.6'
  gem 'rspec-rails', '~> 8.0'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :test do
  # Drive the app like a user in system specs, with headless Firefox for JS
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :development do
  gem 'annotaterb', '~> 4.26'
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.8'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

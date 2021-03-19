# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

rails_version = ENV['RAILS_VERSION'] || 'default'
rails = case rails_version
        when 'main'    then { github: 'rails/rails', branch: 'main' }
        when 'default' then '~> 6.1.0'
        else rails_version
        end
gem 'rails', rails

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.1.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
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
gem 'icasework', '0.1.0.pre5'
gem 'infreemation'

# Background workers
gem 'redis', '~> 4.1.0'
gem 'redis-namespace'
gem 'sidekiq', '~> 5.2'
gem 'sidekiq-scheduler'

# Error reporting
gem 'exception_notification'

gem 'omniauth', '~> 2.0.1'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

gem 'scenic'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem 'bootsnap', '>= 1.1.0', require: false
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.1'
  gem 'rspec-rails', '~> 5.0'
  gem 'rubocop', '~> 1.11.0', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'annotate', '~> 3.1.0'
  # Access an interactive console on exception pages or by calling 'console'
  # anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.5'
  # Use Puma as the app server
  gem 'puma', '~> 5.2'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

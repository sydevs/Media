source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '3.1.3'

# Core gems
gem 'rails', '~> 7.0.4' # Rails itself
gem 'sprockets-rails' # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'pg', '~> 1.1' # Use postgresql as the database for Active Record
gem 'puma', '~> 5.0' # Use the Puma web server [https://github.com/puma/puma]
gem 'sassc-rails' # Use SASS for stylesheets
gem 'slim-rails' # Use Slim for views

# Default rails gems
gem 'importmap-rails' # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'turbo-rails' # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'stimulus-rails' # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
# gem 'jbuilder' # Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem 'redis', '~> 4.0' # Use Redis adapter to run Action Cable in production
# gem 'kredis' # Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem 'bcrypt', '~> 3.1.7' # Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'bootsnap', require: false # Reduces boot times through caching; required in config/boot.rb
# gem 'image_processing', '~> 1.2' # Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]

# API
gem 'httparty'
gem 'dotenv'

# Frontend
gem 'jsbundling-rails' # Javascript bundling
gem 'autoprefixer-rails' # For automatic cross browser CSS compatibility


group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

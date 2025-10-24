source "https://rubygems.org"

gem "blueprinter" # JSON serialization for Rails [https://github.com/blueprinter/blueprinter]

gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb [https://github.com/Shopify/bootsnap]

gem "devise" # Authentication for Rails [https://github.com/heartcombo/devise]

gem "devise-jwt" # Devise for JWT authentication [https://github.com/waiting-for-dev/devise-jwt]

gem "rails", "~> 7.2.2", ">= 7.2.2.2" # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"

gem "pg", "~> 1.1" # Use postgresql as the database for Active Record [https://github.com/ged/ruby-pg]

gem "puma", ">= 5.0" # Use the Puma web server [https://github.com/puma/puma]

gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem

gem "rack-cors" # Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible [https://github.com/cyu/rack-cors]

group :development, :test do
  gem "byebug" # Debugger [https://github.com/dejan/byebug]
  gem "dotenv-rails" # Loads environment variables from .env file [https://github.com/bkeepers/dotenv]
end

group :development do
  gem "annotate" # Annotate models with schema and routes [https://github.com/ctran/annotate_models]
  gem "bullet" # Bullet is a performance profiler for Rails [https://github.com/flyerhzm/bullet]
  gem "brakeman", require: false # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "rubocop" # Ruby code style and lint tool [https://github.com/rubocop/rubocop]
  gem "rubocop-performance", require: false # Performance optimizations for RuboCop [https://github.com/rubocop/rubocop-performance]
  gem "rubocop-rails", require: false # Rails-specific RuboCop rules [https://github.com/rubocop/rubocop-rails]
  gem "web-console" # Use console on exceptions pages [https://github.com/rails/web-console]
end

group :test do
  gem "rspec-rails" # Test framework [https://rspec.info/]
  gem "factory_bot_rails" # Create factory objects for testing [https://github.com/thoughtbot/factory_bot_rails]
  gem "faker" # Generate random data [https://github.com/faker-ruby/faker]
  gem "simplecov" # Code coverage [https://github.com/simplecov-ruby/simplecov]
end

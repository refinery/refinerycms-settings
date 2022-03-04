source "https://rubygems.org"

gemspec

git "https://github.com/refinery/refinerycms", branch: "master" do
  gem "refinerycms"

  group :test do
    gem "refinerycms-testing"
  end
end

# Database Configuration
unless ENV["TRAVIS"]
  gem "activerecord-jdbcsqlite3-adapter", :platform => :jruby
  gem "sqlite3", :platform => :ruby
end

if !ENV["TRAVIS"] || ENV["DB"] == "mysql"
  gem "activerecord-jdbcmysql-adapter", :platform => :jruby
  gem "jdbc-mysql", "= 5.1.13", :platform => :jruby
  gem "mysql2", :platform => :ruby
end

if !ENV['CI'] || ENV['DB'] == 'postgresql'
  group :postgres, :postgresql do
    gem 'activerecord-jdbcpostgresql-adapter', '>= 1.3.0.rc1', platform: :jruby
    gem 'pg', '~> 1.1', platform: :ruby
  end
end

gem "jruby-openssl", :platform => :jruby

# Refinery/rails should pull in the proper versions of these
group :assets do
  gem "sass-rails"
  gem "coffee-rails"
  gem "uglifier"
end

group :development do
  gem 'listen'
end

group :test do
  gem "launchy"
  gem 'capybara-email', '~> 2.4.0'
  gem 'poltergeist'
end

# Load local gems according to Refinery developer preference.
if File.exist? local_gemfile = File.expand_path("../.gemfile", __FILE__)
  eval File.read(local_gemfile)
end

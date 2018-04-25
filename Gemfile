source 'https://rubygems.org'
ruby '2.4'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'rails', '~> 5.0.2'
gem 'puma', '~> 3.0'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'
gem 'ember-cli-rails'
gem 'active_model_serializers', '~> 0.10.0'
gem 'responders'

group :development, :test do
  gem 'sqlite3'
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'fabrication'
  gem 'faker'
end

group :test do
  gem 'shoulda-matchers'
end

group :development do
  # gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'pg'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'rails_12factor', group: [:staging, :production]

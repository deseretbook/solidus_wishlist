source 'https://rubygems.org'

branch = ENV.fetch('SOLIDUS_BRANCH', 'v2.2')

gem 'solidus', github: 'solidusio/solidus', branch: branch
gem 'solidus_auth_devise', '~> 1.0'

if branch == "master" || branch >= "v2.0"
  gem "rails-controller-testing", group: :test
else
  gem "rails", "~> 4.2"
  gem "rails_test_params_backport", group: :test
end

gem 'deface'

group :development, :test do
  # Call `binding.pry` anywhere in the code to stop execution and get a debugger console.
  gem 'byebug'
  gem 'pry-byebug'
  gem 'rubocop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views.
  gem 'web-console'
end

gemspec

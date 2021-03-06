require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'spork'
require 'fakeweb'

Spork.prefork do
  Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}
  Capybara.javascript_driver = :webkit

  RSpec.configure do |config|
    config.mock_with :rspec
    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.include FactoryGirl::Syntax::Methods
  end
end

Spork.each_run do
  FactoryGirl.reload
  RSpec.configuration.seed = srand && srand % 0xFFFF
end

def sign_in
  @person = create(:person)
  visit "/people/sign_in"
  fill_in "Email", :with => @person.email
  fill_in "Password", :with => @person.password
  click_button "Sign in"
end

FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get, 'http://api.meetup.com/2/events/?key=123456789&group_id=7290272', :body => File.expand_path('spec/fixtures/meetup_events_with_group_id.json'))
FakeWeb.register_uri(:get, 'http://api.meetup.com/2/groups/?key=123456789&group_id=7290272', :body => File.expand_path('spec/fixtures/meetup_groups_with_group_id.json'))
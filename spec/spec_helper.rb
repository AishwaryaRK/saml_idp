# encoding: utf-8
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__)

STDERR.puts("Running Specs under Ruby Version #{RUBY_VERSION}")

require "rails_app/config/environment"

require 'rspec'
require 'capybara/rspec'
require 'capybara/rails'

require 'ruby-saml'
require 'saml_idp'
require 'timecop'

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"

  config.include SamlRequestMacros
  config.include SecurityHelpers

  config.before do
    SamlIdp.configure do |c|
      c.attributes = {
        emailAddress: {
          name: "email-address",
          getter: ->(p) { "foo@example.com" }
        }
      }

      c.name_id.formats = {
        "1.1" => {
          email_address: ->(p) { "foo@example.com" }
        }
      }
    end
  end
end

SamlIdp::Default::SERVICE_PROVIDER[:assertion_consumer_logout_service_url] = 'https://foo.example.com/saml/logout'
Capybara.default_host = "https://app.example.com"

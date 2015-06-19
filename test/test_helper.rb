ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb', __FILE__)
require 'rails/test_help'
require 'mocha/setup'
require 'html_test'
require 'byebug'

Rails.backtrace_cleaner.remove_silencers!

include ActionDispatch::TestProcess # Required to make fixture_file_upload work

begin
  require 'turn'
rescue LoadError
  puts 'Install the Turn gem for prettier test output.'
end

# Truncate all tables first
ActiveRecord::Base.connection.tables.each { |table| ActiveRecord::Base.connection.execute("TRUNCATE #{table} CASCADE") }

# Initialize Settler
Settler.load!
Settler.search_default_engine.update_column(:value, 'ferret')

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  self.fixture_path = File.dirname(__FILE__) + '/fixtures/'

  fixtures :all

  # Add more helper methods to be used by all tests here...
  include DevcmsCore::AuthenticatedTestHelper
  include DevcmsCore::RoleRequirementTestHelper

  setup do
    Node.stubs(:try_geocode).returns(
      stub(provider: 'google',
           city: 'Deventer',
           state: 'Gelderland',
           lat: 52.25446,
           lng: 6.160247,
           country: 'NL',
           zip: '',
           street: '',
           street_number: '',
           full_address: 'Deventer',
           distance_to: 0,
           success: true,
           suggested_bounds: [52.25446, 6.160247])
    )
  end

  # Validates all controller and integration test requests if set to true:
  ApplicationController.validate_all = false
  # What html validators to use, options: :w3c, :tidy, :xmllint
  ApplicationController.validators = [:w3c]
  # Check all redirects
  ApplicationController.check_redirects = true
  # Don't check all links
  ApplicationController.check_urls = false
  # Comment the following line when not developing at the office
  Html::Test::Validator.w3c_url = 'http://office.nedforce.nl/w3c-validator/check'

  def get_file_as_string(filename)
    f = File.open(File.dirname(__FILE__) + "/fixtures/#{filename}")
    f.read
  end

  def with_constants(constants, &block)
    constants.each do |constant, val|
      Object.const_set(constant, val)
    end

    block.call

    constants.each do |constant, val|
      Object.send(:remove_const, constant)
    end
  end
end

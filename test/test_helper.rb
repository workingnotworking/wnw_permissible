# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
# ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

require "rails/test_unit/reporter"
Rails::TestUnitReporter.executable = 'bin/test'

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

def assert_association(association, class_name, name, association_class_name, options)
  reflect = class_name.reflect_on_association(name)
  # if we included a source that should be the associated class
  association_class_name = options.delete(:source).to_s.classify if options[:source]
  association_class_name = options.delete(:class_name).to_s.classify if options[:class_name]

  assert_equal association, reflect.macro, "Expected the relationship to be #{association} but was #{reflect.macro}"
  assert_equal association_class_name, reflect.class_name, "Expected the association's class to be #{association_class_name} but was #{reflect.class_name}"
  if options.any?
    options.each do |key, value|
      assert_equal value, reflect.options[key], "Expected option #{key} to be set to #{value}, but isn't"
    end
  end
end

def assert_has_many(class_name, name, options={})
  association_class_name = options.delete(:association_class_name) || name.to_s.camelize.singularize

  assert_association :has_many, class_name, name, association_class_name.try(:to_s), options
end

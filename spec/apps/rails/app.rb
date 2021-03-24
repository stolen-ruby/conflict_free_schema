require 'rails'
require 'active_record/railtie'
require_relative '../../../lib/conflict_free_schema'

class AppUnderTest < Rails::Application
  config.eager_load = false
  config.active_record.schema_format = :sql
end

AppUnderTest.initialize!

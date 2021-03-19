require 'active_support/concern'

module ConflictFreeSchema
  module Database
    module PostgresqlAdapter
      module DumpSchemaVersionsMixin
        extend ActiveSupport::Concern

        def dump_schema_information # :nodoc:
          versions = schema_migration.all_versions
          ConflictFreeSchema::Database::SchemaVersionFiles.touch_all(versions) if versions.any?

          nil
        end
      end
    end
  end
end

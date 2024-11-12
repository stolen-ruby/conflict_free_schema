require 'active_support/concern'

module ConflictFreeSchema
  module Database
    module PostgresqlAdapter
      module DumpSchemaVersionsMixin
        extend ActiveSupport::Concern

        def dump_schema_information # :nodoc:
          if Rails.version >= '7.2.0'
            versions = pool.schema_migration.versions
          elsif Rails.version >= '7.1.0'
            versions = schema_migration.versions
          else
            versions = schema_migration.all_versions
          end

          ConflictFreeSchema::Database::SchemaVersionFiles.touch_all(versions) if versions.any?

          nil
        end
      end
    end
  end
end

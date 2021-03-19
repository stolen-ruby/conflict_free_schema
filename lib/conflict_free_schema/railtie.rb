require 'rails/railtie'

module ConflictFreeSchema
  class Railtie < Rails::Railtie
    initializer "conflict_free_schema.extend_active_record" do
      require 'active_record/connection_adapters/postgresql_adapter'

      # Patch to write version information as empty files under the db/schema_migrations directory
      # This is intended to reduce potential for merge conflicts in db/structure.sql
      ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.prepend(ConflictFreeSchema::Database::PostgresqlAdapter::DumpSchemaVersionsMixin)
      # Patch to load version information from empty files under the db/schema_migrations directory
      ActiveRecord::Tasks::PostgreSQLDatabaseTasks.prepend(ConflictFreeSchema::Database::PostgresqlDatabaseTasks::LoadSchemaVersionsMixin)
    end
  end
end

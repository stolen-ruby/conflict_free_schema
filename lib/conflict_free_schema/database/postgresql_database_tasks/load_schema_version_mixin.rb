module ConflictFreeSchema
  module Database
    module PostgresqlDatabaseTasks
      module LoadSchemaVersionsMixin
        extend ActiveSupport::Concern

        def structure_load(*args)
          super(*args)
          ConflictFreeSchema::Database::SchemaVersionFiles.load_all
        end
      end
    end
  end
end

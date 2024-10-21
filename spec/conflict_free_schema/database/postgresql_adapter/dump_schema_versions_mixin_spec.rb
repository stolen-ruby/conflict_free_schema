# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ConflictFreeSchema::Database::PostgresqlAdapter::DumpSchemaVersionsMixin do
  let(:pool) { double('pool', schema_migration: schema_migration) }
  let(:schema_migration) { double('schema_migration', all_versions: versions, versions: versions) }

  let(:instance) do
    Object.new.extend(described_class)
  end

  before do
    if Rails.version >= "7.2.0"
      allow(instance).to receive(:pool).and_return(pool)
    else
      allow(instance).to receive(:schema_migration).and_return(schema_migration)
    end
  end

  context 'when version files exist' do
    let(:versions) { %w(5 2 1000 200 4 93 2) }

    it 'touches version files' do
      expect(ConflictFreeSchema::Database::SchemaVersionFiles).to receive(:touch_all).with(versions)

      instance.dump_schema_information
    end
  end

  context 'when version files do not exist' do
    let(:versions) { [] }

    it 'does not touch version files' do
      expect(ConflictFreeSchema::Database::SchemaVersionFiles).not_to receive(:touch_all)

      instance.dump_schema_information
    end
  end
end

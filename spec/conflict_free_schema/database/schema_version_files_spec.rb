# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ConflictFreeSchema::Database::SchemaVersionFiles do
  let(:relative_schema_directory) { 'db/schema_migrations' }
  let(:relative_migrate_directory) { 'db/migrate' }
  let(:relative_post_migrate_directory) { 'db/post_migrate' }

  describe '.touch_all' do
    let(:version1) { '20200123' }
    let(:version2) { '20200410' }
    let(:version3) { '20200602' }
    let(:version4) { '20200809' }

    it 'creates a file containing a checksum for each version with a matching migration' do
      Dir.mktmpdir do |tmpdir|
        schema_directory       = Pathname.new(tmpdir).join(relative_schema_directory)
        migrate_directory      = Pathname.new(tmpdir).join(relative_migrate_directory)
        post_migrate_directory = Pathname.new(tmpdir).join(relative_post_migrate_directory)

        FileUtils.mkdir_p(migrate_directory)
        FileUtils.mkdir_p(post_migrate_directory)
        FileUtils.mkdir_p(schema_directory)

        migration1_filepath = migrate_directory.join("#{version1}_migration.rb")
        FileUtils.touch(migration1_filepath)

        migration2_filepath = post_migrate_directory.join("#{version2}_post_migration.rb")
        FileUtils.touch(migration2_filepath)

        old_version_filepath = schema_directory.join('20200101')
        FileUtils.touch(old_version_filepath)

        expect(File.exist?(old_version_filepath)).to be(true)

        allow(described_class).to receive(:schema_directory).and_return(schema_directory)
        allow(described_class).to receive(:migration_directories).and_return(
          [migrate_directory.join('**/*'), post_migrate_directory.join('**/*')]
        )

        described_class.touch_all([version1, version2, version3, version4])

        expect(File.exist?(old_version_filepath)).to be(false)
        [version1, version2].each do |version|
          version_filepath = schema_directory.join(version)
          expect(File.exist?(version_filepath)).to be(true)

          hashed_value = Digest::SHA256.hexdigest(version)
          expect(File.read(version_filepath)).to eq(hashed_value)
        end

        [version3, version4].each do |version|
          version_filepath = schema_directory.join(version)
          expect(File.exist?(version_filepath)).to be(false)
        end
      end
    end

    context 'when "db/migrate" folder contains other subfolders' do
      subject { described_class.touch_all(args) }

      let(:version5) { '20200777' }
      let(:tmpdir) { Dir.mktmpdir }
      let(:schema_directory) { Pathname.new(tmpdir).join(relative_schema_directory) }
      let(:migrate_directory) { Pathname.new(tmpdir).join(relative_migrate_directory) }
      let(:post_migrate_directory) { Pathname.new(tmpdir).join(relative_post_migrate_directory) }
      let!(:create_tmp_directories!) do
        FileUtils.mkdir_p(schema_directory)
        FileUtils.mkdir_p(migrate_directory.join('1.0'))
        FileUtils.mkdir_p(post_migrate_directory.join('1.0'))
      end
      let!(:migration1) { FileUtils.touch migrate_directory.join("#{version1}_migration.rb") }
      let!(:migration2) { FileUtils.touch post_migrate_directory.join("#{version2}_post_migration.rb") }
      let!(:migration3) { FileUtils.touch migrate_directory.join("1.0/#{version3}_migration.rb") }
      let!(:migration4) { FileUtils.touch post_migrate_directory.join("1.0/#{version4}_post_migration.rb") }
      let!(:old_version_filepath) do
        filepath = schema_directory.join('20200101')
        FileUtils.touch(filepath)
        filepath
      end
      let(:args) { [version1, version2, version3, version4, version5] }

      before do
        allow(described_class).to receive(:schema_directory).and_return(schema_directory)
        allow(described_class).to receive(:migration_directories).and_return(
          [migrate_directory.join('**/*'), post_migrate_directory.join('**/*')]
        )
      end

      it 'should remove old timestamp file from schema_migrations folder' do
        expect(File.exist?(old_version_filepath)).to be(true)
        subject
        expect(File.exist?(old_version_filepath)).to be(false)
      end

      it 'should NOT create timestamp file for version5 migration' do
        subject
        expect(File.exist?(schema_directory.join(version5))).to be(false)
      end

      it 'timestamp should be created for each migration file' do
        subject

        [version1, version2, version3, version4].each do |version|
          version_filepath = schema_directory.join(version)
          expect(File.exist?(version_filepath)).to be(true)

          hashed_value = Digest::SHA256.hexdigest(version)
          expect(File.read(version_filepath)).to eq(hashed_value)
        end
      end
    end
  end

  describe '.load_all' do
    let(:connection) { double('connection') }

    before do
      allow(described_class).to receive(:connection).and_return(connection)
      allow(described_class).to receive(:find_version_filenames).and_return(filenames)
    end

    context 'when there are no version files' do
      let(:filenames) { [] }

      it 'does nothing' do
        Dir.mktmpdir do |tmpdir|
          schema_directory = Pathname.new(tmpdir).join(relative_schema_directory)
          allow(described_class).to receive(:schema_directory).and_return(schema_directory)

          expect(connection).not_to receive(:quote_string)
          expect(connection).not_to receive(:execute)

          described_class.load_all
        end
      end
    end

    context 'when there are version files' do
      let(:filenames) { %w[123 456 789] }

      it 'inserts the missing versions into schema_migrations' do
        Dir.mktmpdir do |tmpdir|
          schema_directory = Pathname.new(tmpdir).join(relative_schema_directory)
          allow(described_class).to receive(:schema_directory).and_return(schema_directory)
          filenames.each do |filename|
            expect(connection).to receive(:quote_string).with(filename).and_return(filename)
          end

          expect(connection).to receive(:execute).with(<<~SQL)
            INSERT INTO schema_migrations (version)
            VALUES ('123'),('456'),('789')
            ON CONFLICT DO NOTHING
          SQL

          described_class.load_all
        end
      end
    end
  end
end

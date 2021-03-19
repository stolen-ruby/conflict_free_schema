# frozen_string_literal: true

require 'spec_helper'
require 'open3'

RSpec.describe "Rails 6 integration spec" do
  let(:directory) { File.join(File.dirname(__FILE__), '..', 'apps', 'rails6').to_s }
  let(:schema_migrations_dir){ "#{directory}/db/schema_migrations" }

  after do
    Open3.popen3("rake db:drop", chdir: directory) do |_in, out|
      puts out.read.chomp
      Open3.popen3("rake db:create", chdir: directory) do |_in, out|
        puts out.read.chomp
      end
    end

    FileUtils.rm_rf(schema_migrations_dir)
  end

  it "executes migration successfully" do
    Open3.popen3("rake db:migrate", chdir: directory) do |_stdin, _stdout, _stderr, thread|
      expect(thread.value).to be_success

      Open3.popen3("rake db:version", chdir: directory) do |_stdin, stdout, _stderr, _thread|
        expect(stdout.read.chomp).to eq("Current version: 2021020100000")
      end
    end
  end

  it "produces clean structure dump" do
    Open3.popen3("rake db:migrate", chdir: directory) do |_stdin, _stdout, _stderr, thread|
      expect(thread.value).to be_success

      migrations = Dir.glob('*', base: schema_migrations_dir)
      expect(migrations).to eq(["2021010100000", "2021020100000"])

      structure = File.read("#{directory}/db/structure.sql")
      expect(structure).to include("CREATE TABLE public.schema_migrations")
      expect(structure).not_to include("2021010100000")
      expect(structure).not_to include("2021020100000")
    end
  end

  it "can rollback migration" do
    Open3.popen3("rake db:migrate", chdir: directory) do |_stdin, _stdout, _stderr, thread|
      expect(thread.value).to be_success
    end

    Open3.popen3("rake db:rollback", chdir: directory) do |_stdin, _stdout, _stderr, thread|
      expect(thread.value).to be_success
    end

    migrations = Dir.glob('*', base: schema_migrations_dir)
    expect(migrations).to eq(["2021010100000"])
  end
end

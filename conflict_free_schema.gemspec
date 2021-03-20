Gem::Specification.new do |spec|
  spec.name          = "conflict_free_schema"
  spec.version       = "0.1.0"
  spec.authors       = ["Rafal Wojsznis"]
  spec.email         = ["wojsznis@pm.me"]

  spec.summary       = "Conflict-free schema version handling"
  spec.description   = "Remove conflicts from structure.sql that are caused by tracking the schema_migrations.versions information."
  spec.homepage      = "https://github.com/stolen-ruby/conflict-free-schema"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/stolen-ruby/conflict-free-schema"
  spec.metadata["changelog_uri"] = "https://github.com/stolen-ruby/conflict_free_schema/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(\.github|spec|docker|gemfiles|bin)/}i) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pg"
  spec.add_dependency "rails", "> 5"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "appraisal"
end

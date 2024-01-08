require_relative "lib/sqlite_fts/version"

Gem::Specification.new do |spec|
  spec.name        = "sqlite_fts"
  spec.version     = SqliteFts::VERSION
  spec.authors     = ["Niklas Häusele"]
  spec.email       = ["niklas.haeusele@hey.com"]
  spec.homepage    = "https://www.github.com/codergeek121/sqlite_fts"
  spec.summary     = "Rails plugin to support SQLite FTS"
  spec.description = "All the missing glue to use the SQLite FTS"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # TODO
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.2"
end

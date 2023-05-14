require_relative "lib/roseflow/cli/version"

Gem::Specification.new do |spec|
  spec.name = "roseflow-cli"
  spec.license = "MIT"
  spec.version = Roseflow::Cli.gem_version
  spec.authors = ["Lauri Jutila"]
  spec.email = ["git@laurijutila.com"]

  spec.summary = "Command line interface for Roseflow."
  spec.description = "Command line interface for Roseflow."
  spec.homepage = "https://github.com/roseflow-ai/roseflow-cli"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.2.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/roseflow-ai/roseflow-cli"
  spec.metadata["changelog_uri"] = "https://github.com/roseflow-ai/roseflow-cli/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tty-command"
  spec.add_dependency "tty-progressbar"
  spec.add_dependency "tty-prompt"
  spec.add_dependency "tty-spinner"
  spec.add_dependency "pastel"
  spec.add_dependency "thor"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end

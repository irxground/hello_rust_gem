require "json"
# require_relative 'lib/hello_rust/version'

Gem::Specification.new do |spec|
  cargo_metadata = JSON.parse(`cargo metadata --format-version=1`).dig("packages", 0)

  spec.name = "hello_rust"
  spec.version = cargo_metadata["version"]
  spec.authors = ["irxground"]
  spec.email = ["irxnjhtchlnrw@gmail.com"]

  spec.summary = cargo_metadata["description"]
  spec.homepage = cargo_metadata["homepage"] || cargo_metadata["repository"]
  spec.license = cargo_metadata["license"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = cargo_metadata["repository"]

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  # spec.bindir = "exe"
  # spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  # spec.require_paths = ["lib"]
  spec.extensions = ["ext/Rakefile"]
end

require_relative "lib/fog/vultr/version"

Gem::Specification.new do |spec|
  spec.name = "fog-vultr"
  spec.version = Fog::Vultr::VERSION
  spec.authors = [ "Lewis Buckley" ]
  spec.email = [ "lewis@37signals.com" ]

  spec.summary = "Vultr's compute API (v2) for fog"
  spec.description = "A fog provider for Vultr: instances, plans, regions, operating systems, snapshots, SSH keys and firewall groups, through Vultr's v2 API."
  spec.homepage = "https://github.com/lewispb/fog-vultr"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["lib/**/*.rb", "README.md", "LICENSE"]
  spec.require_paths = [ "lib" ]

  spec.add_dependency "fog-core", "~> 2.6"
  spec.add_dependency "fog-json", "~> 1.2"
end

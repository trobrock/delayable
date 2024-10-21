require_relative "lib/delayable/version"

Gem::Specification.new do |spec|
  spec.name        = "delayable"
  spec.version     = Delayable::VERSION
  spec.authors     = ["Trae Robrock"]
  spec.email       = ["trobrock@gmail.com", "andrew.katz@hey.com"]
  spec.homepage    = "https://github.com/trobrock/delayable"
  spec.summary     = "https://github.com/trobrock/delayable"
  spec.description = "https://github.com/trobrock/delayable"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/trobrock/delayable.git"
  spec.metadata["changelog_uri"] = "https://github.com/trobrock/delayable/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.4.3"
end

require_relative 'lib/delayable/version'

Gem::Specification.new do |spec|
  spec.name        = 'delayable'
  spec.version     = Delayable::VERSION
  spec.authors     = ['Trae Robrock']
  spec.email       = ['trobrock@gmail.com', 'andrew.katz@hey.com']
  spec.homepage    = 'https://github.com/trobrock/delayable'
  spec.summary     = 'https://github.com/trobrock/delayable'
  spec.description = 'https://github.com/trobrock/delayable'
  spec.license     = 'MIT'

  spec.required_ruby_version = '>= 3.4.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/trobrock/delayable.git'
  spec.metadata['changelog_uri'] = 'https://github.com/trobrock/delayable/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w(git ls-files -z), chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w(bin/ test/ spec/ features/ .git appveyor Gemfile))
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 7.0.4.3'
  spec.metadata['rubygems_mfa_required'] = 'true'
end

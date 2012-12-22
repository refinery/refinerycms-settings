# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{refinerycms-settings}
  s.version           = %q{2.1.0.dev}
  s.summary           = %q{Settings engine for Refinery CMS}
  s.description       = %q{Adds programmer creatable, user editable settings.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Philip Arndt', 'Uģis Ozols']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'refinerycms-core', '~> 2.1.0.dev'
  s.add_dependency 'acts_as_indexed',  '~> 0.8.1'
end

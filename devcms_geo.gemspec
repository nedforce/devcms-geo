$:.push File.expand_path('../lib', __FILE__)
require 'devcms_geo/version'

# Provide a simple gemspec so you can easily use your
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name        = 'devcms_geo'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Nedforce Informatica Specialisten B.V.']
  s.email       = ['info@nedforce.nl']
  s.homepage    = 'http://www.nedforce.nl'
  s.summary     = 'Geo engine for Rails 3.2'
  s.description = 'Geo engine for Rails 3.2'
  s.version     = DevcmsGeo::VERSION

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.add_dependency 'devcms_core'
  s.add_dependency 'geokit', '~> 1.6.7'
  s.add_dependency 'geokit-rails'

  s.add_development_dependency 'jakewendt-html_test', '~> 0.2.3'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rsolr', '~> 0.12.1'
  s.add_development_dependency 'acts_as_ferret', '~> 0.5.4'
end

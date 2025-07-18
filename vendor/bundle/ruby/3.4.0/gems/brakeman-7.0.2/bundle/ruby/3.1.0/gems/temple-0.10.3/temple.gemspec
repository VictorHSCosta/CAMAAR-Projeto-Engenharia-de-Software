require File.dirname(__FILE__) + '/lib/temple/version'
require 'date'

Gem::Specification.new do |s|
  s.name          = 'temple'
  s.version       = Temple::VERSION
  s.date          = Date.today.to_s

  s.authors       = ['Magnus Holm', 'Daniel Mendler']
  s.email         = ['judofyr@gmail.com', 'mail@daniel-mendler.de']
  s.homepage      = 'https://github.com/judofyr/temple'
  s.summary       = 'Template compilation framework in Ruby'

  s.require_paths = %w(lib)
  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec)/}) }
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.license       = 'MIT'

  s.required_ruby_version = '>= 2.5.0'

  # Tilt is only development dependency because most parts of Temple
  # can be used without it.
  s.add_development_dependency('tilt')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rake')
  s.add_development_dependency('erubi')
end

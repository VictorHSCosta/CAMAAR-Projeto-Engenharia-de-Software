# -*- encoding: utf-8 -*-
# stub: importmap-rails 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "importmap-rails".freeze
  s.version = "2.1.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/rails/importmap-rails", "source_code_uri" => "https://github.com/rails/importmap-rails" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Heinemeier Hansson".freeze]
  s.date = "2024-12-21"
  s.email = "david@loudthinking.com".freeze
  s.homepage = "https://github.com/rails/importmap-rails".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1.0".freeze)
  s.rubygems_version = "3.5.22".freeze
  s.summary = "Use ESM with importmap to manage modern JavaScript in Rails without transpiling or bundling.".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<railties>.freeze, [">= 6.0.0".freeze])
  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 6.0.0".freeze])
  s.add_runtime_dependency(%q<actionpack>.freeze, [">= 6.0.0".freeze])
end

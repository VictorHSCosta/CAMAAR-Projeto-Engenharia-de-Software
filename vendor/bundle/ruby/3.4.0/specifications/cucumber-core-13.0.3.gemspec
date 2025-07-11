# -*- encoding: utf-8 -*-
# stub: cucumber-core 13.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "cucumber-core".freeze
  s.version = "13.0.3".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 3.0.1".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/cucumber/cucumber-ruby-core/issues", "changelog_uri" => "https://github.com/cucumber/cucumber-ruby-core/blob/master/CHANGELOG.md", "documentation_uri" => "https://www.rubydoc.info/github/cucumber/cucumber-ruby-core", "mailing_list_uri" => "https://groups.google.com/forum/#!forum/cukes", "source_code_uri" => "https://github.com/cucumber/cucumber-ruby-core" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aslak Helles\u00F8y".freeze, "Matt Wynne".freeze, "Steve Tooke".freeze, "Oleg Sukhodolsky".freeze, "Tom Brand".freeze]
  s.date = "2024-07-24"
  s.description = "Core library for the Cucumber BDD app".freeze
  s.email = "cukes@googlegroups.com".freeze
  s.homepage = "https://cucumber.io".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5".freeze)
  s.rubygems_version = "3.3.5".freeze
  s.summary = "cucumber-core-13.0.3".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<cucumber-gherkin>.freeze, [">= 27".freeze, "< 28".freeze])
  s.add_runtime_dependency(%q<cucumber-messages>.freeze, [">= 20".freeze, "< 23".freeze])
  s.add_runtime_dependency(%q<cucumber-tag-expressions>.freeze, ["> 5".freeze, "< 7".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.1".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.13".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.28.2".freeze])
  s.add_development_dependency(%q<rubocop-packaging>.freeze, ["~> 0.5.1".freeze])
  s.add_development_dependency(%q<rubocop-rake>.freeze, ["~> 0.6.0".freeze])
  s.add_development_dependency(%q<rubocop-rspec>.freeze, ["~> 2.10.0".freeze])
end

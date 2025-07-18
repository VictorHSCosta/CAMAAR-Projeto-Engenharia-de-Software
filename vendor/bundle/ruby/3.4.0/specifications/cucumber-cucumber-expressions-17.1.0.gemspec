# -*- encoding: utf-8 -*-
# stub: cucumber-cucumber-expressions 17.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "cucumber-cucumber-expressions".freeze
  s.version = "17.1.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/cucumber/cucumber/issues", "changelog_uri" => "https://github.com/cucumber/cucumber-expressions/blob/main/CHANGELOG.md", "documentation_uri" => "https://github.com/cucumber/cucumber-expressions#readme", "mailing_list_uri" => "https://community.smartbear.com/category/cucumber/discussions/cucumberos", "source_code_uri" => "https://github.com/cucumber/cucumber-expressions/tree/main/ruby" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aslak Helles\u00F8y".freeze]
  s.date = "2024-03-21"
  s.description = "Cucumber Expressions - a simpler alternative to Regular Expressions".freeze
  s.email = "cukes@googlegroups.com".freeze
  s.homepage = "https://github.com/cucumber/cucumber-expressions".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5".freeze)
  s.rubygems_version = "3.4.19".freeze
  s.summary = "cucumber-expressions-17.1.0".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<bigdecimal>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0".freeze, ">= 13.0.6".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.11".freeze, ">= 3.11.0".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.27.0".freeze])
  s.add_development_dependency(%q<rubocop-performance>.freeze, ["~> 1.7.0".freeze])
  s.add_development_dependency(%q<rubocop-rake>.freeze, ["~> 0.5.0".freeze])
  s.add_development_dependency(%q<rubocop-rspec>.freeze, ["~> 2.0.0".freeze])
end

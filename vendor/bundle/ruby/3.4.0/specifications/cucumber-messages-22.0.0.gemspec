# -*- encoding: utf-8 -*-
# stub: cucumber-messages 22.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "cucumber-messages".freeze
  s.version = "22.0.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/cucumber/messages/issues", "changelog_uri" => "https://github.com/cucumber/messages/blob/main/CHANGELOG.md", "documentation_uri" => "https://www.rubydoc.info/github/cucumber/messages", "mailing_list_uri" => "https://groups.google.com/forum/#!forum/cukes", "source_code_uri" => "https://github.com/cucumber/messages" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aslak Helles\u00F8y".freeze]
  s.date = "2023-04-06"
  s.description = "Protocol Buffer messages for Cucumber's inter-process communication".freeze
  s.email = "cukes@googlegroups.com".freeze
  s.homepage = "https://github.com/cucumber/messages-ruby#readme".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3".freeze)
  s.rubygems_version = "3.2.22".freeze
  s.summary = "cucumber-messages-22.0.0".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_development_dependency(%q<cucumber-compatibility-kit>.freeze, ["~> 11.0".freeze, ">= 11.0.0".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0".freeze, ">= 13.0.6".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.11".freeze, ">= 3.11.0".freeze])
end

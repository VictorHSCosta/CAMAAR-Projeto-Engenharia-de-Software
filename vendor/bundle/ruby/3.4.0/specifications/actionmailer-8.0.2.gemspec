# -*- encoding: utf-8 -*-
# stub: actionmailer 8.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "actionmailer".freeze
  s.version = "8.0.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/rails/rails/issues", "changelog_uri" => "https://github.com/rails/rails/blob/v8.0.2/actionmailer/CHANGELOG.md", "documentation_uri" => "https://api.rubyonrails.org/v8.0.2/", "mailing_list_uri" => "https://discuss.rubyonrails.org/c/rubyonrails-talk", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/rails/rails/tree/v8.0.2/actionmailer" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Heinemeier Hansson".freeze]
  s.date = "2025-03-12"
  s.description = "Email on Rails. Compose, deliver, and test emails using the familiar controller/view pattern. First-class support for multipart email and attachments.".freeze
  s.email = "david@loudthinking.com".freeze
  s.homepage = "https://rubyonrails.org".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.2.0".freeze)
  s.requirements = ["none".freeze]
  s.rubygems_version = "3.6.2".freeze
  s.summary = "Email composition and delivery framework (part of Rails).".freeze

  s.installed_by_version = "3.6.7".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<activesupport>.freeze, ["= 8.0.2".freeze])
  s.add_runtime_dependency(%q<actionpack>.freeze, ["= 8.0.2".freeze])
  s.add_runtime_dependency(%q<actionview>.freeze, ["= 8.0.2".freeze])
  s.add_runtime_dependency(%q<activejob>.freeze, ["= 8.0.2".freeze])
  s.add_runtime_dependency(%q<mail>.freeze, [">= 2.8.0".freeze])
  s.add_runtime_dependency(%q<rails-dom-testing>.freeze, ["~> 2.2".freeze])
end

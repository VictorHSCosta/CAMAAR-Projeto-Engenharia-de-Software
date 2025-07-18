begin
  require_relative "lib/irb/version"
rescue LoadError
  # for Ruby core repository
  require_relative "version"
end

Gem::Specification.new do |spec|
  spec.name          = "irb"
  spec.version       = IRB::VERSION
  spec.authors       = ["aycabta", "Keiju ISHITSUKA"]
  spec.email         = ["aycabta@gmail.com", "keiju@ruby-lang.org"]

  spec.summary       = %q{Interactive Ruby command-line tool for REPL (Read Eval Print Loop).}
  spec.description   = %q{Interactive Ruby command-line tool for REPL (Read Eval Print Loop).}
  spec.homepage      = "https://github.com/ruby/irb"
  spec.licenses      = ["Ruby", "BSD-2-Clause"]

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["documentation_uri"] = "https://ruby.github.io/irb/"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"

  spec.files         = [
    "Gemfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "bin/console",
    "bin/setup",
    "doc/irb/irb-tools.rd.ja",
    "doc/irb/irb.rd.ja",
    "exe/irb",
    "irb.gemspec",
    "man/irb.1",
  ] + Dir.chdir(File.expand_path('..', __FILE__)) do
    Dir.glob("lib/**/*").map {|f| f unless File.directory?(f) }.compact
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7")

  spec.add_dependency "reline", ">= 0.4.2"
  spec.add_dependency "rdoc", ">= 4.0.0"
  spec.add_dependency "pp", ">= 0.6.0"
end

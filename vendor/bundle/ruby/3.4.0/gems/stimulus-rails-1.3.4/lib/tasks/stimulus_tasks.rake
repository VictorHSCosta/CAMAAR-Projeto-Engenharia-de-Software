require "stimulus/manifest"

module Stimulus
  module Tasks
    extend self
    def run_stimulus_install_template(path)
      system RbConfig.ruby, "./bin/rails", "app:template", "LOCATION=#{File.expand_path("../install/#{path}.rb",  __dir__)}"
    end

    def using_bun?
      Rails.root.join("bun.config.js").exist?
    end
  end
end

namespace :stimulus do
  desc "Install Stimulus into the app"
  task :install do
    if Rails.root.join("config/importmap.rb").exist?
      Rake::Task["stimulus:install:importmap"].invoke
    elsif Rails.root.join("package.json").exist? && Stimulus::Tasks.using_bun?
      Rake::Task["stimulus:install:bun"].invoke
    elsif Rails.root.join("package.json").exist?
      Rake::Task["stimulus:install:node"].invoke
    else
      puts "You must either be running with node (package.json) or importmap-rails (config/importmap.rb) to use this gem."
    end
  end

  namespace :install do
    desc "Install Stimulus on an app running importmap-rails"
    task :importmap do
      Stimulus::Tasks.run_stimulus_install_template "stimulus_with_importmap"
    end

    desc "Install Stimulus on an app running node"
    task :node do
      Stimulus::Tasks.run_stimulus_install_template "stimulus_with_node"
    end

    desc "Install Stimulus on an app running bun"
    task :bun do
      Stimulus::Tasks.run_stimulus_install_template "stimulus_with_bun"
    end
  end

  namespace :manifest do
    desc "Show the current Stimulus manifest (all installed controllers)"
    task :display do
      puts Stimulus::Manifest.generate_from(Rails.root.join("app/javascript/controllers"))
    end

    desc "Update the Stimulus manifest (will overwrite controllers/index.js)"
    task :update do
      manifest =
        Stimulus::Manifest.generate_from(Rails.root.join("app/javascript/controllers"))

      File.open(Rails.root.join("app/javascript/controllers/index.js"), "w+") do |index|
        index.puts "// This file is auto-generated by ./bin/rails stimulus:manifest:update"
        index.puts "// Run that command whenever you add a new controller or create them with"
        index.puts "// ./bin/rails generate stimulus controllerName"
        index.puts
        index.puts %(import { application } from "./application")
        index.puts manifest
      end
    end
  end
end

# frozen_string_literal: true

require 'yaml'

module Cucumber
  module Cli
    class ProfileLoader
      def initialize
        @cucumber_yml = nil
      end

      def args_from(profile)
        unless cucumber_yml.key?(profile)
          raise(ProfileNotFound, <<~END_OF_ERROR)
            Could not find profile: '#{profile}'

            Defined profiles in cucumber.yml:
              * #{cucumber_yml.keys.sort.join("\n  * ")}
          END_OF_ERROR
        end

        args_from_yml = cucumber_yml[profile] || ''

        case args_from_yml
        when String
          if args_from_yml =~ /^\s*$/
            raise YmlLoadError, "The '#{profile}' profile in cucumber.yml was blank." \
            "  Please define the command line arguments for the '#{profile}' profile in cucumber.yml.\n"
          end

          args_from_yml = processed_shellwords(args_from_yml)
        when Array
          raise YmlLoadError, "The '#{profile}' profile in cucumber.yml was empty.  Please define the command line arguments for the '#{profile}' profile in cucumber.yml.\n" if args_from_yml.empty?
        else
          raise YmlLoadError, "The '#{profile}' profile in cucumber.yml was a #{args_from_yml.class}. It must be a String or Array"
        end

        args_from_yml
      end

      def profile?(profile)
        cucumber_yml.key?(profile)
      end

      def cucumber_yml_defined?
        cucumber_file && File.exist?(cucumber_file)
      end

      private

      # Loads the profile, processing it through ERB and YAML, and returns it as a hash.
      def cucumber_yml
        return @cucumber_yml if @cucumber_yml

        ensure_configuration_file_exists
        process_configuration_file_with_erb
        load_configuration

        if @cucumber_yml.nil? || !@cucumber_yml.is_a?(Hash)
          raise(YmlLoadError, 'cucumber.yml was found, but was blank or malformed. ' \
          "Please refer to cucumber's documentation on correct profile usage.\n")
        end

        @cucumber_yml
      end

      def ensure_configuration_file_exists
        return if cucumber_yml_defined?

        raise(ProfilesNotDefinedError, "cucumber.yml was not found.  Current directory is #{Dir.pwd}." \
                                       "Please refer to cucumber's documentation on defining profiles in cucumber.yml.  You must define" \
                                       "a 'default' profile to use the cucumber command without any arguments.\nType 'cucumber --help' for usage.\n")
      end

      def process_configuration_file_with_erb
        require 'erb'
        begin
          @cucumber_erb = ERB.new(IO.read(cucumber_file), trim_mode: '%').result(binding)
        rescue StandardError
          raise(YmlLoadError, "cucumber.yml was found, but could not be parsed with ERB.  Please refer to cucumber's documentation on correct profile usage.\n#{$ERROR_INFO.inspect}")
        end
      end

      def load_configuration
        require 'yaml'
        begin
          @cucumber_yml = YAML.load(@cucumber_erb)
        rescue StandardError
          raise(YmlLoadError, "cucumber.yml was found, but could not be parsed. Please refer to cucumber's documentation on correct profile usage.\n")
        end
      end

      # Locates cucumber.yml file. The file can end in .yml or .yaml,
      # and be located in the current directory (eg. project root) or
      # in a .config/ or config/ subdirectory of the current directory.
      def cucumber_file
        @cucumber_file ||= Dir.glob('{,.config/,config/}cucumber{.yml,.yaml}').first
      end

      def processed_shellwords(args_from_yml)
        require 'shellwords'

        return Shellwords.shellwords(args_from_yml) unless Cucumber::WINDOWS

        # Shellwords treats backslash as an escape character so we have to mask it out temporarily
        placeholder = 'pseudo_unique_backslash_placeholder'
        sanitized_line = args_from_yml.gsub('\\', placeholder)

        Shellwords.shellwords(sanitized_line).collect { |argument| argument.gsub(placeholder, '\\') }
      end
    end
  end
end

# frozen_string_literal: true

module RuboCop
  module Formatter
    # This formatter displays a YAML configuration file where all cops that
    # detected any offenses are configured to not detect the offense.
    class DisabledConfigFormatter < BaseFormatter
      include PathUtil

      HEADING = <<~COMMENTS
        # This configuration was generated by
        # `%<command>s`
        # %<timestamp>susing RuboCop version #{Version::STRING}.
        # The point is for the user to remove these configuration records
        # one by one as the offenses are removed from the code base.
        # Note that changes in the inspected code, or installation of new
        # versions of RuboCop, may require this file to be generated again.
      COMMENTS

      @config_to_allow_offenses = {}
      @detected_styles = {}

      class << self
        attr_accessor :config_to_allow_offenses, :detected_styles
      end

      def initialize(output, options = {})
        super
        @cops_with_offenses ||= Hash.new(0)
        @files_with_offenses ||= {}
      end

      def file_started(_file, options)
        @config_for_pwd = options[:config_store].for_pwd
        @exclude_limit_option = @options[:exclude_limit]
        @exclude_limit = Integer(@exclude_limit_option ||
          RuboCop::Options::DEFAULT_MAXIMUM_EXCLUSION_ITEMS)
      end

      def file_finished(file, offenses)
        offenses.each do |o|
          @cops_with_offenses[o.cop_name] += 1
          @files_with_offenses[o.cop_name] ||= Set.new
          @files_with_offenses[o.cop_name] << file
        end
      end

      def finished(_inspected_files)
        output.puts format(HEADING, command: command, timestamp: timestamp)

        # Syntax isn't a real cop and it can't be disabled.
        @cops_with_offenses.delete('Lint/Syntax')

        output_offenses

        puts "Created #{output.path}."
      end

      private

      def show_timestamp?
        @options.fetch(:auto_gen_timestamp, true)
      end

      def show_offense_counts?
        @options.fetch(:offense_counts, true)
      end

      def auto_gen_enforced_style?
        @options.fetch(:auto_gen_enforced_style, true)
      end

      def command
        command = 'rubocop --auto-gen-config'

        command += ' --auto-gen-only-exclude' if @options[:auto_gen_only_exclude]

        if no_exclude_limit?
          command += ' --no-exclude-limit'
        elsif @exclude_limit_option
          command += format(' --exclude-limit %<limit>d', limit: Integer(@exclude_limit_option))
        end
        command += ' --no-offense-counts' unless show_offense_counts?

        command += ' --no-auto-gen-timestamp' unless show_timestamp?

        command += ' --no-auto-gen-enforced-style' unless auto_gen_enforced_style?

        command
      end

      def timestamp
        show_timestamp? ? "on #{Time.now.utc} " : ''
      end

      def output_offenses
        @cops_with_offenses.sort.each do |cop_name, offense_count|
          output_cop(cop_name, offense_count)
        end
      end

      def output_cop(cop_name, offense_count)
        output.puts
        cfg = self.class.config_to_allow_offenses[cop_name] || {}
        set_max(cfg, cop_name)

        # To avoid malformed YAML when potentially reading the config in
        # #excludes, we use an output buffer and append it to the actual output
        # only when it results in valid YAML.
        output_buffer = StringIO.new
        output_cop_comments(output_buffer, cfg, cop_name, offense_count)
        output_cop_config(output_buffer, cfg, cop_name)
        output.puts(output_buffer.string)
      end

      def set_max(cfg, cop_name)
        return unless cfg[:exclude_limit]

        cfg.merge!(cfg[:exclude_limit]) if should_set_max?(cop_name)

        # Remove already used exclude_limit.
        cfg.reject! { |key| key == :exclude_limit }
      end

      def should_set_max?(cop_name)
        max_set_in_user_config =
          @config_for_pwd.for_cop(cop_name)['Max'] != default_config(cop_name)['Max']

        max_allowed = !max_set_in_user_config && !no_exclude_limit?
        return false unless max_allowed

        # In case auto_gen_only_exclude is set, only modify the maximum if the files are not
        # excluded one by one.
        !@options[:auto_gen_only_exclude] || @files_with_offenses[cop_name].size > @exclude_limit
      end

      def output_cop_comments(output_buffer, cfg, cop_name, offense_count)
        output_buffer.puts "# Offense count: #{offense_count}" if show_offense_counts?

        cop_class = Cop::Registry.global.find_by_cop_name(cop_name)
        default_cfg = default_config(cop_name)

        if supports_safe_autocorrect?(cop_class, default_cfg)
          output_buffer.puts '# This cop supports safe autocorrection (--autocorrect).'
        elsif supports_unsafe_autocorrect?(cop_class, default_cfg)
          output_buffer.puts '# This cop supports unsafe autocorrection (--autocorrect-all).'
        end

        return unless default_cfg

        params = cop_config_params(default_cfg, cfg)
        return if params.empty?

        output_cop_param_comments(output_buffer, params, default_cfg)
      end

      def supports_safe_autocorrect?(cop_class, default_cfg)
        cop_class&.support_autocorrect? && (default_cfg.nil? || safe_autocorrect?(default_cfg))
      end

      def supports_unsafe_autocorrect?(cop_class, default_cfg)
        cop_class&.support_autocorrect? && !safe_autocorrect?(default_cfg)
      end

      def cop_config_params(default_cfg, cfg)
        default_cfg.keys -
          %w[Description StyleGuide Reference References Enabled Exclude Safe
             SafeAutoCorrect VersionAdded VersionChanged VersionRemoved] -
          cfg.keys
      end

      def output_cop_param_comments(output_buffer, params, default_cfg)
        config_params = params.reject { |p| p.start_with?('Supported') }
        output_buffer.puts("# Configuration parameters: #{config_params.join(', ')}.")

        params.each do |param|
          value = default_cfg[param]
          next unless value.is_a?(Array)
          next if value.empty?

          value.map! { |v| v.nil? ? '~' : v } # Change nil back to ~ as in the YAML file.
          output_buffer.puts "# #{param}: #{value.uniq.join(', ')}"
        end
      end

      def default_config(cop_name)
        RuboCop::ConfigLoader.default_configuration[cop_name]
      end

      def output_cop_config(output_buffer, cfg, cop_name)
        filtered_cfg = filtered_config(cfg)
        output_buffer.puts "#{cop_name}:"
        filtered_cfg.each do |key, value|
          value = value[0] if value.is_a?(Array)
          output_buffer.puts "  #{key}: #{value}"
        end

        output_offending_files(output_buffer, filtered_cfg, cop_name)
      end

      def filtered_config(cfg)
        # 'Enabled' option will be put into file only if exclude
        # limit is exceeded.
        rejected_keys = ['Enabled']
        rejected_keys << /\AEnforcedStyle\w*/ unless auto_gen_enforced_style?
        cfg.reject { |key| include_or_match?(rejected_keys, key) }
      end

      def output_offending_files(output_buffer, cfg, cop_name)
        return unless cfg.empty?

        offending_files = @files_with_offenses[cop_name].sort
        if !no_exclude_limit? && offending_files.count > @exclude_limit
          output_buffer.puts '  Enabled: false'
        else
          output_exclude_list(output_buffer, offending_files, cop_name)
        end
      end

      def output_exclude_list(output_buffer, offending_files, cop_name)
        require 'pathname'
        parent = Pathname.new(Dir.pwd)

        output_buffer.puts '  Exclude:'
        excludes(offending_files, cop_name, parent).each do |exclude_path|
          output_exclude_path(output_buffer, exclude_path, parent)
        end
      end

      def excludes(offending_files, cop_name, parent)
        # Exclude properties in .rubocop_todo.yml override default ones, as well as any custom
        # excludes in .rubocop.yml, so in order to retain those excludes we must copy them.
        # There can be multiple .rubocop.yml files in subdirectories, but we just look at the
        # current working directory.
        config = ConfigStore.new.for(parent)
        cfg = config[cop_name] || {}

        if merge_mode_for_exclude?(config) || merge_mode_for_exclude?(cfg)
          offending_files
        else
          cop_exclude = cfg['Exclude']
          if cop_exclude && cop_exclude != default_config(cop_name)['Exclude']
            warn "`#{cop_name}: Exclude` in `#{smart_path(config.loaded_path)}` overrides a " \
                 'generated `Exclude` in `.rubocop_todo.yml`. Either remove ' \
                 "`#{cop_name}: Exclude` or add `inherit_mode: merge: - Exclude`."
          end
          ((cop_exclude || []) + offending_files).uniq
        end
      end

      def merge_mode_for_exclude?(cfg)
        Array(cfg.to_h.dig('inherit_mode', 'merge')).include?('Exclude')
      end

      def output_exclude_path(output_buffer, exclude_path, parent)
        # exclude_path is either relative path, an absolute path, or a regexp.
        file_path = Pathname.new(exclude_path)
        relative = file_path.relative_path_from(parent)
        output_buffer.puts "    - '#{relative}'"
      rescue ArgumentError
        file = exclude_path
        output_buffer.puts "    - '#{file}'"
      rescue TypeError
        regexp = exclude_path
        output_buffer.puts "    - !ruby/regexp /#{regexp.source}/"
      end

      def safe_autocorrect?(config)
        config.fetch('Safe', true) && config.fetch('SafeAutoCorrect', true)
      end

      def no_exclude_limit?
        @options[:no_exclude_limit] == false
      end

      # Returns true if the given arr include the given elm or if any of the
      # given arr is a regexp that matches the given elm.
      def include_or_match?(arr, elm)
        arr.include?(elm) || arr.any? { |x| x.is_a?(Regexp) && x.match?(elm) }
      end
    end
  end
end

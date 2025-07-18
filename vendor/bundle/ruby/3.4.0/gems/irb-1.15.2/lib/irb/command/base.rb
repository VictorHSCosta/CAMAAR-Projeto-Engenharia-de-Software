# frozen_string_literal: true
#
#   nop.rb -
#   	by Keiju ISHITSUKA(keiju@ruby-lang.org)
#

module IRB
  module Command
    class CommandArgumentError < StandardError; end # :nodoc:

    class << self
      def extract_ruby_args(*args, **kwargs) # :nodoc:
        throw :EXTRACT_RUBY_ARGS, [args, kwargs]
      end
    end

    class Base
      class << self
        def category(category = nil)
          @category = category if category
          @category || "No category"
        end

        def description(description = nil)
          @description = description if description
          @description || "No description provided."
        end

        def help_message(help_message = nil)
          @help_message = help_message if help_message
          @help_message
        end

        def execute(irb_context, arg)
          new(irb_context).execute(arg)
        rescue CommandArgumentError => e
          puts e.message
        end

        private

        def highlight(text)
          Color.colorize(text, [:BOLD, :BLUE])
        end
      end

      def initialize(irb_context)
        @irb_context = irb_context
      end

      attr_reader :irb_context

      def execute(arg)
        #nop
      end
    end

    Nop = Base # :nodoc:
  end
end

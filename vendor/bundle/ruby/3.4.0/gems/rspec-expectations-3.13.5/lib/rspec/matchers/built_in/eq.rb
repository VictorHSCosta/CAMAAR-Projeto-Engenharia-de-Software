module RSpec
  module Matchers
    module BuiltIn
      # @api private
      # Provides the implementation for `eq`.
      # Not intended to be instantiated directly.
      class Eq < BaseMatcher
        # @api private
        # @return [String]
        def failure_message
          if string_encoding_differs?
            "\nexpected: #{format_encoding(expected)} #{expected_formatted}\n     got: #{format_encoding(actual)} #{actual_formatted}\n\n(compared using ==)\n"
          else
            "\nexpected: #{expected_formatted}\n     got: #{actual_formatted}\n\n(compared using ==)\n"
          end
        end

        # @api private
        # @return [String]
        def failure_message_when_negated
          "\nexpected: value != #{expected_formatted}\n     got: #{actual_formatted}\n\n(compared using ==)\n"
        end

        # @api private
        # @return [String]
        def description
          "eq #{expected_formatted}"
        end

        # @api private
        # @return [Boolean]
        def diffable?
          true
        end

      private

        def match(expected, actual)
          actual == expected
        end
      end
    end
  end
end

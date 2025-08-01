# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # Checks to make sure safe navigation isn't used with `blank?` in
      # a conditional.
      #
      # @safety
      #   While the safe navigation operator is generally a good idea, when
      #   checking `foo&.blank?` in a conditional, `foo` being `nil` will actually
      #   do the opposite of what the author intends.
      #
      #   For example:
      #
      #   [source,ruby]
      #   ----
      #   foo&.blank? #=> nil
      #   foo.blank? #=> true
      #   ----
      #
      # @example
      #   # bad
      #   do_something if foo&.blank?
      #   do_something unless foo&.blank?
      #
      #   # good
      #   do_something if foo.blank?
      #   do_something unless foo.blank?
      #
      class SafeNavigationWithBlank < Base
        extend AutoCorrector

        MSG = 'Avoid calling `blank?` with the safe navigation operator in conditionals.'

        def_node_matcher :safe_navigation_blank_in_conditional?, <<~PATTERN
          (if $(csend ... :blank?) ...)
        PATTERN

        def on_if(node)
          return unless safe_navigation_blank_in_conditional?(node)

          add_offense(node) do |corrector|
            corrector.replace(safe_navigation_blank_in_conditional?(node).location.dot, '.')
          end
        end
      end
    end
  end
end

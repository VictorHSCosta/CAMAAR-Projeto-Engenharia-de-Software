# frozen_string_literal: true

module Cucumber
  module Core
    module Test
      class EmptyMultilineArgument
        def describe_to(*)
          self
        end

        def data_table?
          false
        end

        def doc_string?
          false
        end

        def map
          self
        end

        def lines_count
          0
        end

        def inspect
          "#<#{self.class}>"
        end
      end
    end
  end
end

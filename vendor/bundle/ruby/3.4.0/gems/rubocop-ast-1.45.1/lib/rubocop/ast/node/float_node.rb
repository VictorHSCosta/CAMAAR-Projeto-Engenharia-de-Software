# frozen_string_literal: true

module RuboCop
  module AST
    # A node extension for `float` nodes. This will be used in place of a plain
    # node when the builder constructs the AST, making its methods available to
    # all `float` nodes within RuboCop.
    class FloatNode < Node
      include BasicLiteralNode
      include NumericNode
    end
  end
end

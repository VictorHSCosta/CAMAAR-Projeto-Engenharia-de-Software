# frozen_string_literal: true

module RSpec
  module Support
    module FormattingSupport
      def dedent(string)
        string.gsub(/^\s+\|/, '').chomp
      end
    end
  end
end

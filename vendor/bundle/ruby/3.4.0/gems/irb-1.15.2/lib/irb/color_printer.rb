# frozen_string_literal: true
require 'pp'
require_relative 'color'

module IRB
  class ColorPrinter < ::PP
    class << self
      def pp(obj, out = $>, width = screen_width, colorize: true)
        q = ColorPrinter.new(out, width, colorize: colorize)
        q.guard_inspect_key {q.pp obj}
        q.flush
        out << "\n"
      end

      private

      def screen_width
        Reline.get_screen_size.last
      rescue Errno::EINVAL # in `winsize': Invalid argument - <STDIN>
        79
      end
    end

    def initialize(out, width, colorize: true)
      @colorize = colorize

      super(out, width)
    end

    def pp(obj)
      if String === obj
        # Avoid calling Ruby 2.4+ String#pretty_print that splits a string by "\n"
        text(obj.inspect)
      else
        super
      end
    end

    def text(str, width = nil)
      unless str.is_a?(String)
        str = str.inspect
      end
      width ||= str.length

      case str
      when ''
      when ',', '=>', '[', ']', '{', '}', '..', '...', /\A@\w+\z/
        super(str, width)
      when /\A#</, '=', '>'
        super(@colorize ? Color.colorize(str, [:GREEN]) : str, width)
      else
        super(@colorize ? Color.colorize_code(str, ignore_error: true) : str, width)
      end
    end
  end
end

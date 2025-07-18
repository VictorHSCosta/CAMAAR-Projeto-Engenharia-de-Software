# frozen_string_literal: true

module Puma
  # Provides an IO-like object that always appears to contain no data.
  # Used as the value for rack.input when the request has no body.
  #
  class NullIO
    def gets
      nil
    end

    def string
      ""
    end

    def each
    end

    def pos
      0
    end

    # Mimics IO#read with no data.
    #
    def read(length = nil, buffer = nil)
      if length.to_i < 0
        raise ArgumentError, "(negative length #{length} given)"
      end

      buffer = if buffer.nil?
        "".b
      else
        String.try_convert(buffer) or raise TypeError, "no implicit conversion of #{buffer.class} into String"
      end
      buffer.clear
      if length.to_i > 0
        nil
      else
        buffer
      end
    end

    def rewind
    end

    def seek(pos, whence = 0)
      raise ArgumentError, "negative length #{pos} given" if pos.negative?
      0
    end

    def close
    end

    def size
      0
    end

    def eof?
      true
    end

    def sync
      true
    end

    def sync=(v)
    end

    def puts(*ary)
    end

    def write(*ary)
    end

    def flush
      self
    end

    # This is used as singleton class, so can't have state.
    def closed?
      false
    end

    def set_encoding(enc)
      self
    end

    # per rack spec
    def external_encoding
      Encoding::ASCII_8BIT
    end

    def binmode
      self
    end

    def binmode?
      true
    end
  end
end

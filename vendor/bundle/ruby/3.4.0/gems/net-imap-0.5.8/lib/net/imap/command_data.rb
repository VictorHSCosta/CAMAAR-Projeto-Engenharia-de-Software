# frozen_string_literal: true

require "date"

require_relative "errors"
require_relative "data_lite"

module Net
  class IMAP < Protocol

    private

    def validate_data(data)
      case data
      when nil
      when String
      when Integer
        NumValidator.ensure_number(data)
      when Array
        if data[0] == 'CHANGEDSINCE'
          NumValidator.ensure_mod_sequence_value(data[1])
        else
          data.each do |i|
            validate_data(i)
          end
        end
      when Time, Date, DateTime
      when Symbol
      else
        data.validate
      end
    end

    def send_data(data, tag = nil)
      case data
      when nil
        put_string("NIL")
      when String
        send_string_data(data, tag)
      when Integer
        send_number_data(data)
      when Array
        send_list_data(data, tag)
      when Time, DateTime
        send_time_data(data)
      when Date
        send_date_data(data)
      when Symbol
        send_symbol_data(data)
      else
        data.send_data(self, tag)
      end
    end

    def send_string_data(str, tag = nil)
      if str.empty?
        put_string('""')
      elsif str.match?(/[\r\n]/n)
        # literal, because multiline
        send_literal(str, tag)
      elsif !str.ascii_only?
        if @utf8_strings
          # quoted string
          send_quoted_string(str)
        else
          # literal, because of non-ASCII bytes
          send_literal(str, tag)
        end
      elsif str.match?(/[(){ \x00-\x1f\x7f%*"\\]/n)
        # quoted string
        send_quoted_string(str)
      else
        put_string(str)
      end
    end

    def send_quoted_string(str)
      put_string('"' + str.gsub(/["\\]/, "\\\\\\&") + '"')
    end

    def send_literal(str, tag = nil)
      synchronize do
        put_string("{" + str.bytesize.to_s + "}" + CRLF)
        @continued_command_tag = tag
        @continuation_request_exception = nil
        begin
          @continuation_request_arrival.wait
          e = @continuation_request_exception || @exception
          raise e if e
          put_string(str)
        ensure
          @continued_command_tag = nil
          @continuation_request_exception = nil
        end
      end
    end

    def send_number_data(num)
      put_string(num.to_s)
    end

    def send_list_data(list, tag = nil)
      put_string("(")
      first = true
      list.each do |i|
        if first
          first = false
        else
          put_string(" ")
        end
        send_data(i, tag)
      end
      put_string(")")
    end

    def send_date_data(date) put_string Net::IMAP.encode_date(date) end
    def send_time_data(time) put_string Net::IMAP.encode_time(time) end

    def send_symbol_data(symbol)
      put_string("\\" + symbol.to_s)
    end

    CommandData = Data.define(:data) do # :nodoc:
      def send_data(imap, tag)
        raise NoMethodError, "#{self.class} must implement #{__method__}"
      end

      def validate
      end
    end

    class RawData < CommandData # :nodoc:
      def send_data(imap, tag)
        imap.__send__(:put_string, data)
      end
    end

    class Atom < CommandData # :nodoc:
      def send_data(imap, tag)
        imap.__send__(:put_string, data)
      end
    end

    class QuotedString < CommandData # :nodoc:
      def send_data(imap, tag)
        imap.__send__(:send_quoted_string, data)
      end
    end

    class Literal < CommandData # :nodoc:
      def send_data(imap, tag)
        imap.__send__(:send_literal, data, tag)
      end
    end

    class PartialRange < CommandData # :nodoc:
      uint32_max = 2**32 - 1
      POS_RANGE = 1..uint32_max
      NEG_RANGE = -uint32_max..-1
      Positive = ->{ (_1 in Range) and POS_RANGE.cover?(_1) }
      Negative = ->{ (_1 in Range) and NEG_RANGE.cover?(_1) }

      def initialize(data:)
        min, max = case data
        in Range
          data.minmax.map { Integer _1 }
        in ResponseParser::Patterns::PARTIAL_RANGE
          data.split(":").map { Integer _1 }.minmax
        else
          raise ArgumentError, "invalid partial range input: %p" % [data]
        end
        data = min..max
        unless data in Positive | Negative
          raise ArgumentError, "invalid partial-range: %p" % [data]
        end
        super
      rescue TypeError, RangeError
        raise ArgumentError, "expected range min/max to be Integers"
      end

      def formatted = "%d:%d" % data.minmax

      def send_data(imap, tag)
        imap.__send__(:put_string, formatted)
      end
    end

    # *DEPRECATED*.  Replaced by SequenceSet.
    class MessageSet < CommandData # :nodoc:
      def send_data(imap, tag)
        imap.__send__(:put_string, format_internal(data))
      end

      def validate
        validate_internal(data)
      end

      private

      def initialize(data:)
        super
        warn("DEPRECATED: #{MessageSet} should be replaced with #{SequenceSet}.",
             uplevel: 1, category: :deprecated)
        begin
          # to ensure the input works with SequenceSet, too
          SequenceSet.new(data)
        rescue
          warn "MessageSet input is incompatible with SequenceSet: [%s] %s" % [
            $!.class, $!.message
          ]
        end
      end

      def format_internal(data)
        case data
        when "*"
          return data
        when Integer
          if data == -1
            return "*"
          else
            return data.to_s
          end
        when Range
          return format_internal(data.first) +
            ":" + format_internal(data.last)
        when Array
          return data.collect {|i| format_internal(i)}.join(",")
        when ThreadMember
          return data.seqno.to_s +
            ":" + data.children.collect {|i| format_internal(i).join(",")}
        end
      end

      def validate_internal(data)
        case data
        when "*"
        when Integer
          NumValidator.ensure_nz_number(data)
        when Range
        when Array
          data.each do |i|
            validate_internal(i)
          end
        when ThreadMember
          data.children.each do |i|
            validate_internal(i)
          end
        else
          raise DataFormatError, data.inspect
        end
      end
    end

    class ClientID < CommandData # :nodoc:

      def send_data(imap, tag)
        imap.__send__(:send_data, format_internal(data), tag)
      end

      def validate
        validate_internal(data)
      end

      private

      def validate_internal(client_id)
        client_id.to_h.each do |k,v|
          unless StringFormatter.valid_string?(k)
            raise DataFormatError, client_id.inspect
          end
        end
      rescue NoMethodError, TypeError # to_h failed
        raise DataFormatError, client_id.inspect
      end

      def format_internal(client_id)
        return nil if client_id.nil?
        client_id.to_h.flat_map {|k,v|
          [StringFormatter.string(k), StringFormatter.nstring(v)]
        }
      end

    end

    module StringFormatter

      LITERAL_REGEX = /[\x80-\xff\r\n]/n

      module_function

      # Allows symbols in addition to strings
      def valid_string?(str)
        str.is_a?(Symbol) || str.respond_to?(:to_str)
      end

      # Allows nil, symbols, and strings
      def valid_nstring?(str)
        str.nil? || valid_string?(str)
      end

      # coerces using +to_s+
      def string(str)
        str = str.to_s
        if str =~ LITERAL_REGEX
          Literal.new(str)
        else
          QuotedString.new(str)
        end
      end

      # coerces non-nil using +to_s+
      def nstring(str)
        str.nil? ? nil : string(str)
      end

    end

  end
end

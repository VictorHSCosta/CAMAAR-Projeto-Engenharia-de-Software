# frozen_string_literal: true
##
# A section of table

class RDoc::Markup::Table
  # headers of each column
  attr_accessor :header

  # alignments of each column
  attr_accessor :align

  # body texts of each column
  attr_accessor :body

  # Creates new instance
  def initialize(header, align, body)
    @header, @align, @body = header, align, body
  end

  # :stopdoc:
  def ==(other)
    self.class == other.class and
      @header == other.header and
      @align == other.align and
      @body == other.body
  end

  def accept(visitor)
    visitor.accept_table @header, @body, @align
  end

  def pretty_print(q)
    q.group 2, '[Table: ', ']' do
      q.group 2, '[Head: ', ']' do
        q.seplist @header.zip(@align) do |text, align|
          q.pp text
          if align
            q.text ":"
            q.breakable
            q.text align.to_s
          end
        end
      end
      q.breakable
      q.group 2, '[Body: ', ']' do
        q.seplist @body do |body|
          q.group 2, '[', ']' do
            q.seplist body do |text|
              q.pp text
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

# Represents a simplistic (non-contextual) change. Represents the removal or
# addition of an element from either the old or the new sequenced
# enumerable.
class Diff::LCS::Change
  IntClass = 1.class # Fixnum is deprecated in Ruby 2.4 # standard:disable Naming/ConstantName

  # The only actions valid for changes are '+' (add), '-' (delete), '='
  # (no change), '!' (changed), '<' (tail changes from first sequence), or
  # '>' (tail changes from second sequence). The last two ('<>') are only
  # found with Diff::LCS::diff and Diff::LCS::sdiff.
  VALID_ACTIONS = %w[+ - = ! > <].freeze

  def self.valid_action?(action)
    VALID_ACTIONS.include? action
  end

  # Returns the action this Change represents.
  attr_reader :action

  # Returns the position of the Change.
  attr_reader :position
  # Returns the sequence element of the Change.
  attr_reader :element

  def initialize(*args)
    @action, @position, @element = *args

    fail "Invalid Change Action '#{@action}'" unless Diff::LCS::Change.valid_action?(@action)
    fail "Invalid Position Type" unless @position.is_a? IntClass
  end

  def inspect(*_args)
    "#<#{self.class}: #{to_a.inspect}>"
  end

  def to_a
    [@action, @position, @element]
  end

  alias_method :to_ary, :to_a

  def self.from_a(arr)
    arr = arr.flatten(1)
    case arr.size
    when 5
      Diff::LCS::ContextChange.new(*arr[0...5])
    when 3
      Diff::LCS::Change.new(*arr[0...3])
    else
      fail "Invalid change array format provided."
    end
  end

  include Comparable

  def ==(other)
    (self.class == other.class) and
      (action == other.action) and
      (position == other.position) and
      (element == other.element)
  end

  def <=>(other)
    r = action <=> other.action
    r = position <=> other.position if r.zero?
    r = element <=> other.element if r.zero?
    r
  end

  def adding?
    @action == "+"
  end

  def deleting?
    @action == "-"
  end

  def unchanged?
    @action == "="
  end

  def changed?
    @action == "!"
  end

  def finished_a?
    @action == ">"
  end

  def finished_b?
    @action == "<"
  end
end

# Represents a contextual change. Contains the position and values of the
# elements in the old and the new sequenced enumerables as well as the action
# taken.
class Diff::LCS::ContextChange < Diff::LCS::Change
  # We don't need these two values.
  undef :position
  undef :element

  # Returns the old position being changed.
  attr_reader :old_position
  # Returns the new position being changed.
  attr_reader :new_position
  # Returns the old element being changed.
  attr_reader :old_element
  # Returns the new element being changed.
  attr_reader :new_element

  def initialize(*args)
    @action, @old_position, @old_element, @new_position, @new_element = *args

    fail "Invalid Change Action '#{@action}'" unless Diff::LCS::Change.valid_action?(@action)
    fail "Invalid (Old) Position Type" unless @old_position.nil? || @old_position.is_a?(IntClass)
    fail "Invalid (New) Position Type" unless @new_position.nil? || @new_position.is_a?(IntClass)
  end

  def to_a
    [
      @action,
      [@old_position, @old_element],
      [@new_position, @new_element]
    ]
  end

  alias_method :to_ary, :to_a

  def self.from_a(arr)
    Diff::LCS::Change.from_a(arr)
  end

  # Simplifies a context change for use in some diff callbacks. '<' actions
  # are converted to '-' and '>' actions are converted to '+'.
  def self.simplify(event)
    ea = event.to_a

    case ea[0]
    when "-"
      ea[2][1] = nil
    when "<"
      ea[0] = "-"
      ea[2][1] = nil
    when "+"
      ea[1][1] = nil
    when ">"
      ea[0] = "+"
      ea[1][1] = nil
    end

    Diff::LCS::ContextChange.from_a(ea)
  end

  def ==(other)
    (self.class == other.class) and
      (@action == other.action) and
      (@old_position == other.old_position) and
      (@new_position == other.new_position) and
      (@old_element == other.old_element) and
      (@new_element == other.new_element)
  end

  def <=>(other)
    r = @action <=> other.action
    r = @old_position <=> other.old_position if r.zero?
    r = @new_position <=> other.new_position if r.zero?
    r = @old_element <=> other.old_element if r.zero?
    r = @new_element <=> other.new_element if r.zero?
    r
  end
end

# Ripper translation

Prism provides the ability to mirror the `Ripper` standard library. You can do this by:

```ruby
require "prism/translation/ripper/shim"
```

This provides the APIs like:

```ruby
Ripper.lex
Ripper.parse
Ripper.sexp_raw
Ripper.sexp

Ripper::SexpBuilder
Ripper::SexpBuilderPP
```

Briefly, `Ripper` is a streaming parser that allows you to construct your own syntax tree. As an example:

```ruby
class ArithmeticRipper < Prism::Translation::Ripper
  def on_binary(left, operator, right)
    left.public_send(operator, right)
  end

  def on_int(value)
    value.to_i
  end

  def on_program(stmts)
    stmts
  end

  def on_stmts_new
    []
  end

  def on_stmts_add(stmts, stmt)
    stmts << stmt
    stmts
  end
end

ArithmeticRipper.new("1 + 2 - 3").parse # => [0]
```

The exact names of the `on_*` methods are listed in the `Ripper` source.

## Background

It is helpful to understand the differences between the `Ripper` library and the `Prism` library. Both libraries perform parsing and provide you with APIs to manipulate and understand the resulting syntax tree. However, there are a few key differences.

### Design

`Ripper` is a streaming parser. This means as it is parsing Ruby code, it dispatches events back to the consumer. This allows quite a bit of flexibility. You can use it to build your own syntax tree or to find specific patterns in the code. `Prism` on the other hand returns to your the completed syntax tree _before_ it allows you to manipulate it. This means the tree that you get back is the only representation that can be generated by the parser _at parse time_ (but of course can be manipulated later).

### Fields

We use the term "field" to mean a piece of information on a syntax tree node. `Ripper` provides the minimal number of fields to accurately represent the syntax tree for the purposes of compilation/interpretation. For example, in the callbacks for nodes that are based on keywords (`class`, `module`, `for`, `while`, etc.) you are not given the keyword itself, you need to attach it on your own. In other cases, tokens are not necessarily dispatched at all, meaning you need to find them yourself. `Prism` provides the opposite: the maximum number of fields on nodes is provided. As a tradeoff, this requires more memory, but this is chosen to make it easier on consumers.

### Maintainability

The `Ripper` interface is not guaranteed in any way, and tends to change between patch versions of CRuby. This is largely due to the fact that `Ripper` is a by-product of the generated parser, as opposed to its own parser. As an example, in the expression `foo::bar = baz`, there are three different represents possible for the call operator, including:

* `:"::"` - Ruby 1.9 to Ruby 3.1.4
* `73` - Ruby 3.1.5 to Ruby 3.1.6
* `[:@op, "::", [lineno, column]]` - Ruby 3.2.0 and later

The `Prism` interface is guaranteed going forward to be the consistent, and the official Ruby syntax tree interface. This means you can rely on this interface without having to worry about individual changes between Ruby versions. It also is a gem, which means it is versioned based on the gem version, as opposed to being versioned based on the Ruby version. Finally, you can use `Prism` to parse multiple versions of Ruby, whereas `Ripper` is tied to the Ruby version it is running on.

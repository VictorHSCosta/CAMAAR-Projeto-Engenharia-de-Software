# frozen_string_literal: true
require 'ripper'

##
# Wrapper for Ripper lex states

class RDoc::Parser::RipperStateLex
  # :stopdoc:

  Token = Struct.new(:line_no, :char_no, :kind, :text, :state)

  EXPR_END   = Ripper::EXPR_END
  EXPR_ENDFN = Ripper::EXPR_ENDFN
  EXPR_ARG   = Ripper::EXPR_ARG
  EXPR_FNAME = Ripper::EXPR_FNAME

  class InnerStateLex < Ripper::Filter
    def initialize(code)
      super(code)
    end

    def on_default(event, tok, data)
      data << Token.new(lineno, column, event, tok, state)
    end
  end

  def get_squashed_tk
    if @buf.empty?
      tk = @tokens.shift
    else
      tk = @buf.shift
    end
    return nil if tk.nil?
    case tk[:kind]
    when :on_symbeg then
      tk = get_symbol_tk(tk)
    when :on_tstring_beg then
      tk = get_string_tk(tk)
    when :on_backtick then
      if (tk[:state] & (EXPR_FNAME | EXPR_ENDFN)) != 0
        tk[:kind] = :on_ident
        tk[:state] = Ripper::Lexer::State.new(EXPR_ARG)
      else
        tk = get_string_tk(tk)
      end
    when :on_regexp_beg then
      tk = get_regexp_tk(tk)
    when :on_embdoc_beg then
      tk = get_embdoc_tk(tk)
    when :on_heredoc_beg then
      @heredoc_queue << retrieve_heredoc_info(tk)
    when :on_nl, :on_ignored_nl, :on_comment, :on_heredoc_end then
      if !@heredoc_queue.empty?
        get_heredoc_tk(*@heredoc_queue.shift)
      elsif tk[:text].nil? # :on_ignored_nl sometimes gives nil
        tk[:text] = ''
      end
    when :on_words_beg then
      tk = get_words_tk(tk)
    when :on_qwords_beg then
      tk = get_words_tk(tk)
    when :on_symbols_beg then
      tk = get_words_tk(tk)
    when :on_qsymbols_beg then
      tk = get_words_tk(tk)
    when :on_op then
      if '&.' == tk[:text]
        tk[:kind] = :on_period
      else
        tk = get_op_tk(tk)
      end
    end
    tk
  end

  private def get_symbol_tk(tk)
    is_symbol = true
    symbol_tk = Token.new(tk.line_no, tk.char_no, :on_symbol)
    if ":'" == tk[:text] or ':"' == tk[:text] or tk[:text].start_with?('%s')
      tk1 = get_string_tk(tk)
      symbol_tk[:text] = tk1[:text]
      symbol_tk[:state] = tk1[:state]
    else
      case (tk1 = get_squashed_tk)[:kind]
      when :on_ident
        symbol_tk[:text] = ":#{tk1[:text]}"
        symbol_tk[:state] = tk1[:state]
      when :on_tstring_content
        symbol_tk[:text] = ":#{tk1[:text]}"
        symbol_tk[:state] = get_squashed_tk[:state] # skip :on_tstring_end
      when :on_tstring_end
        symbol_tk[:text] = ":#{tk1[:text]}"
        symbol_tk[:state] = tk1[:state]
      when :on_op
        symbol_tk[:text] = ":#{tk1[:text]}"
        symbol_tk[:state] = tk1[:state]
      when :on_ivar
        symbol_tk[:text] = ":#{tk1[:text]}"
        symbol_tk[:state] = tk1[:state]
      when :on_cvar
        symbol_tk[:text] = ":#{tk1[:text]}"
        symbol_tk[:state] = tk1[:state]
      when :on_gvar
        symbol_tk[:text] = ":#{tk1[:text]}"
        symbol_tk[:state] = tk1[:state]
      when :on_const
        symbol_tk[:text] = ":#{tk1[:text]}"
        symbol_tk[:state] = tk1[:state]
      when :on_kw
        symbol_tk[:text] = ":#{tk1[:text]}"
        symbol_tk[:state] = tk1[:state]
      else
        is_symbol = false
        tk = tk1
      end
    end
    if is_symbol
      tk = symbol_tk
    end
    tk
  end

  private def get_string_tk(tk)
    string = tk[:text]
    state = nil
    kind = :on_tstring
    loop do
      inner_str_tk = get_squashed_tk
      if inner_str_tk.nil?
        break
      elsif :on_tstring_end == inner_str_tk[:kind]
        string = string + inner_str_tk[:text]
        state = inner_str_tk[:state]
        break
      elsif :on_label_end == inner_str_tk[:kind]
        string = string + inner_str_tk[:text]
        state = inner_str_tk[:state]
        kind = :on_symbol
        break
      else
        string = string + inner_str_tk[:text]
        if :on_embexpr_beg == inner_str_tk[:kind] then
          kind = :on_dstring if :on_tstring == kind
        end
      end
    end
    Token.new(tk.line_no, tk.char_no, kind, string, state)
  end

  private def get_regexp_tk(tk)
    string = tk[:text]
    state = nil
    loop do
      inner_str_tk = get_squashed_tk
      if inner_str_tk.nil?
        break
      elsif :on_regexp_end == inner_str_tk[:kind]
        string = string + inner_str_tk[:text]
        state = inner_str_tk[:state]
        break
      else
        string = string + inner_str_tk[:text]
      end
    end
    Token.new(tk.line_no, tk.char_no, :on_regexp, string, state)
  end

  private def get_embdoc_tk(tk)
    string = tk[:text]
    until :on_embdoc_end == (embdoc_tk = get_squashed_tk)[:kind] do
      string = string + embdoc_tk[:text]
    end
    string = string + embdoc_tk[:text]
    Token.new(tk.line_no, tk.char_no, :on_embdoc, string, embdoc_tk.state)
  end

  private def get_heredoc_tk(heredoc_name, indent)
    string = ''
    start_tk = nil
    prev_tk = nil
    until heredoc_end?(heredoc_name, indent, tk = @tokens.shift) do
      start_tk = tk unless start_tk
      if (prev_tk.nil? or "\n" == prev_tk[:text][-1]) and 0 != tk[:char_no]
        string = string + (' ' * tk[:char_no])
      end
      string = string + tk[:text]
      prev_tk = tk
    end
    start_tk = tk unless start_tk
    prev_tk = tk unless prev_tk
    @buf.unshift tk # closing heredoc
    heredoc_tk = Token.new(start_tk.line_no, start_tk.char_no, :on_heredoc, string, prev_tk.state)
    @buf.unshift heredoc_tk
  end

  private def retrieve_heredoc_info(tk)
    name = tk[:text].gsub(/\A<<[-~]?(['"`]?)(.+)\1\z/, '\2')
    indent = tk[:text] =~ /\A<<[-~]/
    [name, indent]
  end

  private def heredoc_end?(name, indent, tk)
    result = false
    if :on_heredoc_end == tk[:kind] then
      tk_name = tk[:text].chomp
      tk_name.lstrip! if indent
      if name == tk_name
        result = true
      end
    end
    result
  end

  private def get_words_tk(tk)
    string = ''
    start_token = tk[:text]
    start_quote = tk[:text].rstrip[-1]
    line_no = tk[:line_no]
    char_no = tk[:char_no]
    state = tk[:state]
    end_quote =
      case start_quote
      when ?( then ?)
      when ?[ then ?]
      when ?{ then ?}
      when ?< then ?>
      else start_quote
      end
    end_token = nil
    loop do
      tk = get_squashed_tk
      if tk.nil?
        end_token = end_quote
        break
      elsif :on_tstring_content == tk[:kind] then
        string += tk[:text]
      elsif :on_words_sep == tk[:kind] or :on_tstring_end == tk[:kind] then
        if end_quote == tk[:text].strip then
          end_token = tk[:text]
          break
        else
          string += tk[:text]
        end
      else
        string += tk[:text]
      end
    end
    text = "#{start_token}#{string}#{end_token}"
    Token.new(line_no, char_no, :on_dstring, text, state)
  end

  private def get_op_tk(tk)
    redefinable_operators = %w[! != !~ % & * ** + +@ - -@ / < << <= <=> == === =~ > >= >> [] []= ^ ` | ~]
    if redefinable_operators.include?(tk[:text]) and tk[:state] == EXPR_ARG then
      tk[:state] = Ripper::Lexer::State.new(EXPR_ARG)
      tk[:kind] = :on_ident
    elsif tk[:text] =~ /^[-+]$/ then
      tk_ahead = get_squashed_tk
      case tk_ahead[:kind]
      when :on_int, :on_float, :on_rational, :on_imaginary then
        tk[:text] += tk_ahead[:text]
        tk[:kind] = tk_ahead[:kind]
        tk[:state] = tk_ahead[:state]
      when :on_heredoc_beg, :on_tstring, :on_dstring # frozen/non-frozen string literal
        tk[:text] += tk_ahead[:text]
        tk[:kind] = tk_ahead[:kind]
        tk[:state] = tk_ahead[:state]
      else
        @buf.unshift tk_ahead
      end
    end
    tk
  end

  # :startdoc:

  # New lexer for +code+.
  def initialize(code)
    @buf = []
    @heredoc_queue = []
    @inner_lex = InnerStateLex.new(code)
    @tokens = @inner_lex.parse([])
  end

  # Returns tokens parsed from +code+.
  def self.parse(code)
    lex = self.new(code)
    tokens = []
    begin
      while tk = lex.get_squashed_tk
        tokens.push tk
      end
    rescue StopIteration
    end
    tokens
  end

  # Returns +true+ if lex state will be +END+ after +token+.
  def self.end?(token)
    (token[:state] & EXPR_END)
  end
end

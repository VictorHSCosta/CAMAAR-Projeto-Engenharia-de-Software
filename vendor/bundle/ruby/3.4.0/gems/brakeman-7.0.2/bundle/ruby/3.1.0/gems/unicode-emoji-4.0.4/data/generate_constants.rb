require_relative '../lib/unicode/emoji/constants'
require_relative '../lib/unicode/emoji/index'
require_relative '../lib/unicode/emoji/lazy_constants'

include Unicode::Emoji

def write_regexes(regexes, dirpath)
  regexes.each do |const_name, regex|
    write_regex(const_name, regex, dirpath)
  end
end

def write_regex(const_name, regex, dirpath)
  filename = const_name.to_s.downcase
  filepath = File.join(dirpath, "#{filename}.rb")

  File.write(filepath, <<~CONTENT)
    # This file was generated by a script, please do not edit it by hand.
    # See `$ rake generate_constants` and data/generate_constants.rb for more info.

    module Unicode
      module Emoji
        #{const_name} = #{regex.inspect}
      end
    end
  CONTENT
  puts "#{const_name} written to #{filepath}"
end

# Converts [1, 2, 3, 5, 6, 20, 21, 22, 23, 100] (it does not need to be sorted) to [[1, 2, 3], [5, 6], [20, 21, 22, 23], [100]]
def groupify(arr)
  arr = arr.sort
  prev = nil
  arr.slice_before do |el|
    (prev.nil? || el != prev + 1).tap { prev = el }
  end
end

# Converts [1, 2, 3, 5, 6, 20, 21, 22, 23, 100] (it does not need to be sorted) to [1..3, 5, 6, 20..23, 100]
def rangify(arr)
  groupify(arr).map do |group|
    group.size < 3 ? group : Range.new(group.first, group.last)
  end.flatten
end

def pack(ord)
  Regexp.escape(Array(ord).pack("U*"))
end

def join(*strings)
  "(?:" + strings.join("|") + ")"
end

def character_class(ords_with_ranges)
  "[" + ords_with_ranges.map{ |ord_or_range|
      ord_or_range.is_a?(Range) ?
        pack(ord_or_range.first) + "-" + pack(ord_or_range.last) :
        pack(ord_or_range)
    }.join +
  "]"
end

def pack_and_join(ords)
  if ords.any? { |e| e.is_a?(Array) }
    join(*ords.map { |ord| pack(ord) })
  else
    character_class(rangify(ords))
  end
end

def compile(emoji_character:, emoji_modifier:, emoji_modifier_base:, emoji_component:, emoji_presentation:, text_presentation:, picto:, picto_no_emoji:)
  visual_component = pack_and_join(VISUAL_COMPONENT)

  emoji_presentation_sequence = \
    join(
      text_presentation + pack(EMOJI_VARIATION_SELECTOR),
      emoji_presentation + "(?!" + pack(TEXT_VARIATION_SELECTOR) + ")" + pack(EMOJI_VARIATION_SELECTOR) + "?",
    )

  non_component_emoji_presentation_sequence = \
    "(?!" + emoji_component + ")" + emoji_presentation_sequence

  basic_emoji = \
    join(
      non_component_emoji_presentation_sequence,
      visual_component,
    )

  text_keycap_sequence = \
    pack_and_join(EMOJI_KEYCAPS) + pack(EMOJI_KEYCAP_SUFFIX)

  text_presentation_sequence = \
    join(
      text_presentation + "(?!" + join(emoji_modifier, pack(EMOJI_VARIATION_SELECTOR)) + ")" + pack(TEXT_VARIATION_SELECTOR) + "?",
      emoji_presentation + pack(TEXT_VARIATION_SELECTOR),
    )

  text_emoji = \
    join(
      "(?!" + emoji_component + ")" + text_presentation_sequence,
      text_keycap_sequence,
    )

  emoji_modifier_sequence = \
    emoji_modifier_base + emoji_modifier

  emoji_keycap_sequence = \
    pack_and_join(EMOJI_KEYCAPS) + pack([EMOJI_VARIATION_SELECTOR, EMOJI_KEYCAP_SUFFIX])

  emoji_valid_flag_sequence = \
    pack_and_join(VALID_REGION_FLAGS)

  emoji_well_formed_flag_sequence = \
    '\p{RI}{2}'

  emoji_core_sequence = \
    join(
      emoji_keycap_sequence,
      emoji_modifier_sequence,
      non_component_emoji_presentation_sequence,
    )

  # Sort to make sure complex sequences match first
  emoji_rgi_tag_sequence = \
    pack_and_join(RECOMMENDED_SUBDIVISION_FLAGS.sort_by(&:length).reverse)

  emoji_valid_tag_sequence = \
    "(?:" +
      pack(EMOJI_TAG_BASE_FLAG) +
      "(?:" + VALID_SUBDIVISIONS.sort_by(&:length).reverse.map{ |sd|
        sd.tr("\u{30}-\u{39}\u{61}-\u{7A}", "\u{E0030}-\u{E0039}\u{E0061}-\u{E007A}")
      }.join("|") + ")" +
      pack(CANCEL_TAG) +
    ")"

  emoji_well_formed_tag_sequence = \
    "(?:" +
      join(
        non_component_emoji_presentation_sequence,
        emoji_modifier_sequence,
      ) +
      pack_and_join(SPEC_TAGS) + "{1,30}" +
      pack(CANCEL_TAG) +
    ")"

  # Sort to make sure complex sequences match first
  emoji_rgi_zwj_sequence = \
    pack_and_join(RECOMMENDED_ZWJ_SEQUENCES.sort_by(&:length).reverse)

  # FQE+MQE: Make VS16 optional after ZWJ has appeared
  emoji_rgi_include_mqe_zwj_sequence = emoji_rgi_zwj_sequence.gsub(
      /#{ pack(ZWJ) }[^|]+?\K#{ pack(EMOJI_VARIATION_SELECTOR) }/,
      pack(EMOJI_VARIATION_SELECTOR) + "?"
    )

  # FQE+MQE+UQE: Make all VS16 optional
  emoji_rgi_include_mqe_uqe_zwj_sequence = emoji_rgi_zwj_sequence.gsub(
      pack(EMOJI_VARIATION_SELECTOR),
      pack(EMOJI_VARIATION_SELECTOR) + "?",
    )

  emoji_valid_zwj_element = \
    join(
      emoji_modifier_sequence,
      emoji_presentation_sequence,
      emoji_character,
    )

  emoji_valid_zwj_sequence = \
    "(?:" +
      "(?:" + emoji_valid_zwj_element + pack(ZWJ) + ")+" + emoji_valid_zwj_element +
    ")"

  emoji_rgi_sequence = \
    join(
      emoji_rgi_zwj_sequence,
      emoji_rgi_tag_sequence,
      emoji_valid_flag_sequence,
      emoji_core_sequence,
      visual_component,
    )

  emoji_rgi_sequence_include_text = \
    join(
      emoji_rgi_zwj_sequence,
      emoji_rgi_tag_sequence,
      emoji_valid_flag_sequence,
      emoji_core_sequence,
      visual_component,
      text_emoji,
    )

  emoji_rgi_include_mqe_sequence = \
    join(
      emoji_rgi_include_mqe_zwj_sequence,
      emoji_rgi_tag_sequence,
      emoji_valid_flag_sequence,
      emoji_core_sequence,
      visual_component,
    )

  emoji_rgi_include_mqe_uqe_sequence = \
    join(
      emoji_rgi_include_mqe_uqe_zwj_sequence,
      text_emoji, # also uqe
      emoji_rgi_tag_sequence,
      emoji_valid_flag_sequence,
      emoji_core_sequence,
      visual_component,
    )

  emoji_valid_sequence = \
    join(
      emoji_valid_zwj_sequence,
      emoji_valid_tag_sequence,
      emoji_valid_flag_sequence,
      emoji_core_sequence,
      visual_component,
    )

  emoji_valid_sequence_include_text = \
    join(
      emoji_valid_zwj_sequence,
      emoji_valid_tag_sequence,
      emoji_valid_flag_sequence,
      emoji_core_sequence,
      visual_component,
      text_emoji,
    )

  emoji_well_formed_sequence = \
    join(
      emoji_valid_zwj_sequence,
      emoji_well_formed_tag_sequence,
      emoji_well_formed_flag_sequence,
      emoji_core_sequence,
      visual_component,
    )

  emoji_well_formed_sequence_include_text = \
    join(
      emoji_valid_zwj_sequence,
      emoji_well_formed_tag_sequence,
      emoji_well_formed_flag_sequence,
      emoji_core_sequence,
      visual_component,
      text_emoji,
    )

  emoji_possible_modification = \
    join(
      emoji_modifier,
      pack([EMOJI_VARIATION_SELECTOR, EMOJI_KEYCAP_SUFFIX]) + "?",
      "[󠀠-󠁾]+󠁿" # raw tags
    )

  emoji_possible_zwj_element = \
    join(
      emoji_well_formed_flag_sequence,
      emoji_character + emoji_possible_modification + "?"
    )

  emoji_possible = \
    emoji_possible_zwj_element + "(?:" + pack(ZWJ) + emoji_possible_zwj_element + ")*"

  regexes = {}

  # Matches basic singleton emoji and all kind of sequences, but restrict zwj and tag sequences to known sequences (rgi)
  regexes[:REGEX] = Regexp.compile(emoji_rgi_sequence)

  # rgi + singleton text
  regexes[:REGEX_INCLUDE_TEXT] = Regexp.compile(emoji_rgi_sequence_include_text)

  # Matches basic singleton emoji and all kind of sequences, but restrict zwj and tag sequences to known sequences (rgi)
  # Also make VS16 optional if not at first emoji character
  regexes[:REGEX_INCLUDE_MQE] = Regexp.compile(emoji_rgi_include_mqe_sequence)

  # Matches basic singleton emoji and all kind of sequences, but restrict zwj and tag sequences to known sequences (rgi)
  # Also make VS16 optional even at first emoji character
  regexes[:REGEX_INCLUDE_MQE_UQE] = Regexp.compile(emoji_rgi_include_mqe_uqe_sequence)

  # Matches basic singleton emoji and all kind of valid sequences
  regexes[:REGEX_VALID] = Regexp.compile(emoji_valid_sequence)

  # valid + singleton text
  regexes[:REGEX_VALID_INCLUDE_TEXT] = Regexp.compile(emoji_valid_sequence_include_text)
  
  # Matches basic singleton emoji and all kind of sequences
  regexes[:REGEX_WELL_FORMED] = Regexp.compile(emoji_well_formed_sequence)
  
  # well-formed + singleton text
  regexes[:REGEX_WELL_FORMED_INCLUDE_TEXT] = Regexp.compile(emoji_well_formed_sequence_include_text)

  # Quick test which might lead to false positves
  # See https://www.unicode.org/reports/tr51/#EBNF_and_Regex
  regexes[:REGEX_POSSIBLE] = Regexp.compile(emoji_possible)

  # Matches only basic single, non-textual emoji, ignores some components like simple digits
  regexes[:REGEX_BASIC] = Regexp.compile(basic_emoji)

  # Matches only basic single, textual emoji, ignores components like modifiers or simple digits
  regexes[:REGEX_TEXT] = Regexp.compile(text_emoji)
  regexes[:REGEX_TEXT_PRESENTATION] = Regexp.compile(text_presentation)

  # Export regexes for Emoji properties so they can be used with newer Unicode than Ruby's
  regexes[:REGEX_PROP_EMOJI] = Regexp.compile(emoji_character)
  regexes[:REGEX_PROP_MODIFIER] = Regexp.compile(emoji_modifier)
  regexes[:REGEX_PROP_MODIFIER_BASE] = Regexp.compile(emoji_modifier_base)
  regexes[:REGEX_PROP_COMPONENT] = Regexp.compile(emoji_component)
  regexes[:REGEX_PROP_PRESENTATION] = Regexp.compile(emoji_presentation)

  # Same goes for ExtendedPictographic
  regexes[:REGEX_PICTO] = Regexp.compile(picto)
  regexes[:REGEX_PICTO_NO_EMOJI] = Regexp.compile(picto_no_emoji)

  # Emoji keycaps
  regexes[:REGEX_EMOJI_KEYCAP] = Regexp.compile(emoji_keycap_sequence)

  regexes
end

regexes = compile(
  emoji_character:      pack_and_join(EMOJI_CHAR),
  emoji_modifier:       pack_and_join(EMOJI_MODIFIERS),
  emoji_modifier_base:  pack_and_join(EMOJI_MODIFIER_BASES),
  emoji_component:      pack_and_join(EMOJI_COMPONENT),
  emoji_presentation:   pack_and_join(EMOJI_PRESENTATION),
  text_presentation:    pack_and_join(TEXT_PRESENTATION),
  picto:                pack_and_join(EXTENDED_PICTOGRAPHIC),
  picto_no_emoji:       pack_and_join(EXTENDED_PICTOGRAPHIC_NO_EMOJI)
)
write_regexes(regexes, File.expand_path("../lib/unicode/emoji/generated", __dir__))

native_regexes = compile(
  emoji_character:      "\\p{Emoji}",
  emoji_modifier:       "\\p{EMod}",
  emoji_modifier_base:  "\\p{EBase}",
  emoji_component:      "\\p{EComp}",
  emoji_presentation:   "\\p{EPres}",
  text_presentation:    "[\\p{Emoji}&&\\P{EPres}]",
  picto:                "\\p{ExtPict}",
  picto_no_emoji:       "[\\p{ExtPict}&&\\P{Emoji}]"
)
write_regexes(native_regexes, File.expand_path("../lib/unicode/emoji/generated_native", __dir__))

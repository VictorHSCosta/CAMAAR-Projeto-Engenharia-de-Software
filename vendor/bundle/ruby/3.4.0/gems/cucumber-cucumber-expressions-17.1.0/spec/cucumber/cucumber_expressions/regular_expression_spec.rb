# frozen_string_literal: true

require 'yaml'
require 'cucumber/cucumber_expressions/regular_expression'
require 'cucumber/cucumber_expressions/parameter_type_registry'

module Cucumber
  module CucumberExpressions
    describe RegularExpression do
      Dir['../testdata/regular-expression/matching/*.yaml'].each do |path|
        expectation = YAML.load_file(path)

        it "matches #{path}" do
          parameter_registry = ParameterTypeRegistry.new
          expression = described_class.new(Regexp.new(expectation['expression']), parameter_registry)
          matches = expression.match(expectation['text'])
          values = matches.map { |arg| arg.value(nil) }

          expect(values).to eq(expectation['expected_args'])
        end
      end

      it 'does not transform by default' do
        expect(match(/(\d\d)/, '22')).to eq(['22'])
      end

      it 'does not transform anonymous' do
        expect(match(/(.*)/, '22')).to eq(['22'])
      end

      it 'transforms negative int' do
        expect(match(/(-?\d+)/, '-22')).to eq([-22])
      end

      it 'transforms positive int' do
        expect(match(/(\d+)/, '22')).to eq([22])
      end

      it 'returns nil when there is no match' do
        expect(match(/hello/, 'world')).to be_nil
      end

      it 'matches empty string when there is an empty string match' do
        expect(match(/^The value equals "([^"]*)"$/, 'The value equals ""')).to eq([''])
      end

      it 'matches nested capture group without match' do
        expect(match(/^a user( named "([^"]*)")?$/, 'a user')).to eq([nil])
      end

      it 'matches nested capture group with match' do
        expect(match(/^a user( named "([^"]*)")?$/, 'a user named "Charlie"')).to eq(['Charlie'])
      end

      it 'ignores non capturing groups' do
        expect(
          match(
            /(\S+) ?(can|cannot) (?:delete|cancel) the (\d+)(?:st|nd|rd|th) (attachment|slide) ?(?:upload)?/,
            'I can cancel the 1st slide upload'
          )
        ).to eq(['I', 'can', 1, 'slide'])
      end

      it 'matches capture group nested in optional one' do
        regexp = /^a (pre-commercial transaction |pre buyer fee model )?purchase(?: for \$(\d+))?$/

        expect(match(regexp, 'a purchase')).to eq([nil, nil])
        expect(match(regexp, 'a purchase for $33')).to eq([nil, 33])
        expect(match(regexp, 'a pre buyer fee model purchase')).to eq(['pre buyer fee model ', nil])
      end

      it 'works with escaped parentheses' do
        expect(match(/Across the line\(s\)/, 'Across the line(s)')).to eq([])
      end

      it 'exposes source and regexp' do
        regexp = /I have (\d+) cukes? in my (\+) now/
        expression = described_class.new(regexp, ParameterTypeRegistry.new)

        expect(expression.regexp).to eq(regexp)
        expect(expression.source).to eq(regexp.source)
      end

      def match(expression, text)
        regular_expression = RegularExpression.new(expression, ParameterTypeRegistry.new)
        arguments = regular_expression.match(text)
        return nil if arguments.nil?

        arguments.map { |arg| arg.value(nil) }
      end
    end
  end
end

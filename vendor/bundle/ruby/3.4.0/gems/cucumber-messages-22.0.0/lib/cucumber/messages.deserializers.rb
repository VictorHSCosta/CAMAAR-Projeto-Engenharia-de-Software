require 'cucumber/messages.dtos'
require 'json'

# The code was auto-generated by {this script}[https://github.com/cucumber/messages/blob/main/jsonschema/scripts/codegen.rb]
#

module Cucumber
  module Messages

    class Attachment

      ##
      # Returns a new Attachment from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Attachment.from_h(some_hash) # => #<Cucumber::Messages::Attachment:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          body: hash[:body],
          content_encoding: hash[:contentEncoding],
          file_name: hash[:fileName],
          media_type: hash[:mediaType],
          source: Source.from_h(hash[:source]),
          test_case_started_id: hash[:testCaseStartedId],
          test_step_id: hash[:testStepId],
          url: hash[:url],
        )
      end
    end

    class Duration

      ##
      # Returns a new Duration from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Duration.from_h(some_hash) # => #<Cucumber::Messages::Duration:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          seconds: hash[:seconds],
          nanos: hash[:nanos],
        )
      end
    end

    class Envelope

      ##
      # Returns a new Envelope from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Envelope.from_h(some_hash) # => #<Cucumber::Messages::Envelope:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          attachment: Attachment.from_h(hash[:attachment]),
          gherkin_document: GherkinDocument.from_h(hash[:gherkinDocument]),
          hook: Hook.from_h(hash[:hook]),
          meta: Meta.from_h(hash[:meta]),
          parameter_type: ParameterType.from_h(hash[:parameterType]),
          parse_error: ParseError.from_h(hash[:parseError]),
          pickle: Pickle.from_h(hash[:pickle]),
          source: Source.from_h(hash[:source]),
          step_definition: StepDefinition.from_h(hash[:stepDefinition]),
          test_case: TestCase.from_h(hash[:testCase]),
          test_case_finished: TestCaseFinished.from_h(hash[:testCaseFinished]),
          test_case_started: TestCaseStarted.from_h(hash[:testCaseStarted]),
          test_run_finished: TestRunFinished.from_h(hash[:testRunFinished]),
          test_run_started: TestRunStarted.from_h(hash[:testRunStarted]),
          test_step_finished: TestStepFinished.from_h(hash[:testStepFinished]),
          test_step_started: TestStepStarted.from_h(hash[:testStepStarted]),
          undefined_parameter_type: UndefinedParameterType.from_h(hash[:undefinedParameterType]),
        )
      end
    end

    class Exception

      ##
      # Returns a new Exception from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Exception.from_h(some_hash) # => #<Cucumber::Messages::Exception:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          type: hash[:type],
          message: hash[:message],
        )
      end
    end

    class GherkinDocument

      ##
      # Returns a new GherkinDocument from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::GherkinDocument.from_h(some_hash) # => #<Cucumber::Messages::GherkinDocument:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          uri: hash[:uri],
          feature: Feature.from_h(hash[:feature]),
          comments: hash[:comments]&.map { |item| Comment.from_h(item) },
        )
      end
    end

    class Background

      ##
      # Returns a new Background from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Background.from_h(some_hash) # => #<Cucumber::Messages::Background:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          keyword: hash[:keyword],
          name: hash[:name],
          description: hash[:description],
          steps: hash[:steps]&.map { |item| Step.from_h(item) },
          id: hash[:id],
        )
      end
    end

    class Comment

      ##
      # Returns a new Comment from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Comment.from_h(some_hash) # => #<Cucumber::Messages::Comment:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          text: hash[:text],
        )
      end
    end

    class DataTable

      ##
      # Returns a new DataTable from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::DataTable.from_h(some_hash) # => #<Cucumber::Messages::DataTable:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          rows: hash[:rows]&.map { |item| TableRow.from_h(item) },
        )
      end
    end

    class DocString

      ##
      # Returns a new DocString from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::DocString.from_h(some_hash) # => #<Cucumber::Messages::DocString:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          media_type: hash[:mediaType],
          content: hash[:content],
          delimiter: hash[:delimiter],
        )
      end
    end

    class Examples

      ##
      # Returns a new Examples from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Examples.from_h(some_hash) # => #<Cucumber::Messages::Examples:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          tags: hash[:tags]&.map { |item| Tag.from_h(item) },
          keyword: hash[:keyword],
          name: hash[:name],
          description: hash[:description],
          table_header: TableRow.from_h(hash[:tableHeader]),
          table_body: hash[:tableBody]&.map { |item| TableRow.from_h(item) },
          id: hash[:id],
        )
      end
    end

    class Feature

      ##
      # Returns a new Feature from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Feature.from_h(some_hash) # => #<Cucumber::Messages::Feature:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          tags: hash[:tags]&.map { |item| Tag.from_h(item) },
          language: hash[:language],
          keyword: hash[:keyword],
          name: hash[:name],
          description: hash[:description],
          children: hash[:children]&.map { |item| FeatureChild.from_h(item) },
        )
      end
    end

    class FeatureChild

      ##
      # Returns a new FeatureChild from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::FeatureChild.from_h(some_hash) # => #<Cucumber::Messages::FeatureChild:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          rule: Rule.from_h(hash[:rule]),
          background: Background.from_h(hash[:background]),
          scenario: Scenario.from_h(hash[:scenario]),
        )
      end
    end

    class Rule

      ##
      # Returns a new Rule from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Rule.from_h(some_hash) # => #<Cucumber::Messages::Rule:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          tags: hash[:tags]&.map { |item| Tag.from_h(item) },
          keyword: hash[:keyword],
          name: hash[:name],
          description: hash[:description],
          children: hash[:children]&.map { |item| RuleChild.from_h(item) },
          id: hash[:id],
        )
      end
    end

    class RuleChild

      ##
      # Returns a new RuleChild from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::RuleChild.from_h(some_hash) # => #<Cucumber::Messages::RuleChild:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          background: Background.from_h(hash[:background]),
          scenario: Scenario.from_h(hash[:scenario]),
        )
      end
    end

    class Scenario

      ##
      # Returns a new Scenario from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Scenario.from_h(some_hash) # => #<Cucumber::Messages::Scenario:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          tags: hash[:tags]&.map { |item| Tag.from_h(item) },
          keyword: hash[:keyword],
          name: hash[:name],
          description: hash[:description],
          steps: hash[:steps]&.map { |item| Step.from_h(item) },
          examples: hash[:examples]&.map { |item| Examples.from_h(item) },
          id: hash[:id],
        )
      end
    end

    class Step

      ##
      # Returns a new Step from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Step.from_h(some_hash) # => #<Cucumber::Messages::Step:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          keyword: hash[:keyword],
          keyword_type: hash[:keywordType],
          text: hash[:text],
          doc_string: DocString.from_h(hash[:docString]),
          data_table: DataTable.from_h(hash[:dataTable]),
          id: hash[:id],
        )
      end
    end

    class TableCell

      ##
      # Returns a new TableCell from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TableCell.from_h(some_hash) # => #<Cucumber::Messages::TableCell:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          value: hash[:value],
        )
      end
    end

    class TableRow

      ##
      # Returns a new TableRow from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TableRow.from_h(some_hash) # => #<Cucumber::Messages::TableRow:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          cells: hash[:cells]&.map { |item| TableCell.from_h(item) },
          id: hash[:id],
        )
      end
    end

    class Tag

      ##
      # Returns a new Tag from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Tag.from_h(some_hash) # => #<Cucumber::Messages::Tag:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          location: Location.from_h(hash[:location]),
          name: hash[:name],
          id: hash[:id],
        )
      end
    end

    class Hook

      ##
      # Returns a new Hook from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Hook.from_h(some_hash) # => #<Cucumber::Messages::Hook:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          id: hash[:id],
          name: hash[:name],
          source_reference: SourceReference.from_h(hash[:sourceReference]),
          tag_expression: hash[:tagExpression],
        )
      end
    end

    class Location

      ##
      # Returns a new Location from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Location.from_h(some_hash) # => #<Cucumber::Messages::Location:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          line: hash[:line],
          column: hash[:column],
        )
      end
    end

    class Meta

      ##
      # Returns a new Meta from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Meta.from_h(some_hash) # => #<Cucumber::Messages::Meta:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          protocol_version: hash[:protocolVersion],
          implementation: Product.from_h(hash[:implementation]),
          runtime: Product.from_h(hash[:runtime]),
          os: Product.from_h(hash[:os]),
          cpu: Product.from_h(hash[:cpu]),
          ci: Ci.from_h(hash[:ci]),
        )
      end
    end

    class Ci

      ##
      # Returns a new Ci from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Ci.from_h(some_hash) # => #<Cucumber::Messages::Ci:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          name: hash[:name],
          url: hash[:url],
          build_number: hash[:buildNumber],
          git: Git.from_h(hash[:git]),
        )
      end
    end

    class Git

      ##
      # Returns a new Git from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Git.from_h(some_hash) # => #<Cucumber::Messages::Git:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          remote: hash[:remote],
          revision: hash[:revision],
          branch: hash[:branch],
          tag: hash[:tag],
        )
      end
    end

    class Product

      ##
      # Returns a new Product from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Product.from_h(some_hash) # => #<Cucumber::Messages::Product:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          name: hash[:name],
          version: hash[:version],
        )
      end
    end

    class ParameterType

      ##
      # Returns a new ParameterType from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::ParameterType.from_h(some_hash) # => #<Cucumber::Messages::ParameterType:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          name: hash[:name],
          regular_expressions: hash[:regularExpressions],
          prefer_for_regular_expression_match: hash[:preferForRegularExpressionMatch],
          use_for_snippets: hash[:useForSnippets],
          id: hash[:id],
          source_reference: SourceReference.from_h(hash[:sourceReference]),
        )
      end
    end

    class ParseError

      ##
      # Returns a new ParseError from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::ParseError.from_h(some_hash) # => #<Cucumber::Messages::ParseError:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          source: SourceReference.from_h(hash[:source]),
          message: hash[:message],
        )
      end
    end

    class Pickle

      ##
      # Returns a new Pickle from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Pickle.from_h(some_hash) # => #<Cucumber::Messages::Pickle:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          id: hash[:id],
          uri: hash[:uri],
          name: hash[:name],
          language: hash[:language],
          steps: hash[:steps]&.map { |item| PickleStep.from_h(item) },
          tags: hash[:tags]&.map { |item| PickleTag.from_h(item) },
          ast_node_ids: hash[:astNodeIds],
        )
      end
    end

    class PickleDocString

      ##
      # Returns a new PickleDocString from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::PickleDocString.from_h(some_hash) # => #<Cucumber::Messages::PickleDocString:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          media_type: hash[:mediaType],
          content: hash[:content],
        )
      end
    end

    class PickleStep

      ##
      # Returns a new PickleStep from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::PickleStep.from_h(some_hash) # => #<Cucumber::Messages::PickleStep:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          argument: PickleStepArgument.from_h(hash[:argument]),
          ast_node_ids: hash[:astNodeIds],
          id: hash[:id],
          type: hash[:type],
          text: hash[:text],
        )
      end
    end

    class PickleStepArgument

      ##
      # Returns a new PickleStepArgument from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::PickleStepArgument.from_h(some_hash) # => #<Cucumber::Messages::PickleStepArgument:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          doc_string: PickleDocString.from_h(hash[:docString]),
          data_table: PickleTable.from_h(hash[:dataTable]),
        )
      end
    end

    class PickleTable

      ##
      # Returns a new PickleTable from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::PickleTable.from_h(some_hash) # => #<Cucumber::Messages::PickleTable:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          rows: hash[:rows]&.map { |item| PickleTableRow.from_h(item) },
        )
      end
    end

    class PickleTableCell

      ##
      # Returns a new PickleTableCell from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::PickleTableCell.from_h(some_hash) # => #<Cucumber::Messages::PickleTableCell:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          value: hash[:value],
        )
      end
    end

    class PickleTableRow

      ##
      # Returns a new PickleTableRow from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::PickleTableRow.from_h(some_hash) # => #<Cucumber::Messages::PickleTableRow:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          cells: hash[:cells]&.map { |item| PickleTableCell.from_h(item) },
        )
      end
    end

    class PickleTag

      ##
      # Returns a new PickleTag from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::PickleTag.from_h(some_hash) # => #<Cucumber::Messages::PickleTag:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          name: hash[:name],
          ast_node_id: hash[:astNodeId],
        )
      end
    end

    class Source

      ##
      # Returns a new Source from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Source.from_h(some_hash) # => #<Cucumber::Messages::Source:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          uri: hash[:uri],
          data: hash[:data],
          media_type: hash[:mediaType],
        )
      end
    end

    class SourceReference

      ##
      # Returns a new SourceReference from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::SourceReference.from_h(some_hash) # => #<Cucumber::Messages::SourceReference:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          uri: hash[:uri],
          java_method: JavaMethod.from_h(hash[:javaMethod]),
          java_stack_trace_element: JavaStackTraceElement.from_h(hash[:javaStackTraceElement]),
          location: Location.from_h(hash[:location]),
        )
      end
    end

    class JavaMethod

      ##
      # Returns a new JavaMethod from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::JavaMethod.from_h(some_hash) # => #<Cucumber::Messages::JavaMethod:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          class_name: hash[:className],
          method_name: hash[:methodName],
          method_parameter_types: hash[:methodParameterTypes],
        )
      end
    end

    class JavaStackTraceElement

      ##
      # Returns a new JavaStackTraceElement from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::JavaStackTraceElement.from_h(some_hash) # => #<Cucumber::Messages::JavaStackTraceElement:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          class_name: hash[:className],
          file_name: hash[:fileName],
          method_name: hash[:methodName],
        )
      end
    end

    class StepDefinition

      ##
      # Returns a new StepDefinition from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::StepDefinition.from_h(some_hash) # => #<Cucumber::Messages::StepDefinition:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          id: hash[:id],
          pattern: StepDefinitionPattern.from_h(hash[:pattern]),
          source_reference: SourceReference.from_h(hash[:sourceReference]),
        )
      end
    end

    class StepDefinitionPattern

      ##
      # Returns a new StepDefinitionPattern from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::StepDefinitionPattern.from_h(some_hash) # => #<Cucumber::Messages::StepDefinitionPattern:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          source: hash[:source],
          type: hash[:type],
        )
      end
    end

    class TestCase

      ##
      # Returns a new TestCase from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TestCase.from_h(some_hash) # => #<Cucumber::Messages::TestCase:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          id: hash[:id],
          pickle_id: hash[:pickleId],
          test_steps: hash[:testSteps]&.map { |item| TestStep.from_h(item) },
        )
      end
    end

    class Group

      ##
      # Returns a new Group from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Group.from_h(some_hash) # => #<Cucumber::Messages::Group:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          children: hash[:children]&.map { |item| Group.from_h(item) },
          start: hash[:start],
          value: hash[:value],
        )
      end
    end

    class StepMatchArgument

      ##
      # Returns a new StepMatchArgument from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::StepMatchArgument.from_h(some_hash) # => #<Cucumber::Messages::StepMatchArgument:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          group: Group.from_h(hash[:group]),
          parameter_type_name: hash[:parameterTypeName],
        )
      end
    end

    class StepMatchArgumentsList

      ##
      # Returns a new StepMatchArgumentsList from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::StepMatchArgumentsList.from_h(some_hash) # => #<Cucumber::Messages::StepMatchArgumentsList:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          step_match_arguments: hash[:stepMatchArguments]&.map { |item| StepMatchArgument.from_h(item) },
        )
      end
    end

    class TestStep

      ##
      # Returns a new TestStep from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TestStep.from_h(some_hash) # => #<Cucumber::Messages::TestStep:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          hook_id: hash[:hookId],
          id: hash[:id],
          pickle_step_id: hash[:pickleStepId],
          step_definition_ids: hash[:stepDefinitionIds],
          step_match_arguments_lists: hash[:stepMatchArgumentsLists]&.map { |item| StepMatchArgumentsList.from_h(item) },
        )
      end
    end

    class TestCaseFinished

      ##
      # Returns a new TestCaseFinished from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TestCaseFinished.from_h(some_hash) # => #<Cucumber::Messages::TestCaseFinished:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          test_case_started_id: hash[:testCaseStartedId],
          timestamp: Timestamp.from_h(hash[:timestamp]),
          will_be_retried: hash[:willBeRetried],
        )
      end
    end

    class TestCaseStarted

      ##
      # Returns a new TestCaseStarted from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TestCaseStarted.from_h(some_hash) # => #<Cucumber::Messages::TestCaseStarted:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          attempt: hash[:attempt],
          id: hash[:id],
          test_case_id: hash[:testCaseId],
          worker_id: hash[:workerId],
          timestamp: Timestamp.from_h(hash[:timestamp]),
        )
      end
    end

    class TestRunFinished

      ##
      # Returns a new TestRunFinished from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TestRunFinished.from_h(some_hash) # => #<Cucumber::Messages::TestRunFinished:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          message: hash[:message],
          success: hash[:success],
          timestamp: Timestamp.from_h(hash[:timestamp]),
          exception: Exception.from_h(hash[:exception]),
        )
      end
    end

    class TestRunStarted

      ##
      # Returns a new TestRunStarted from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TestRunStarted.from_h(some_hash) # => #<Cucumber::Messages::TestRunStarted:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          timestamp: Timestamp.from_h(hash[:timestamp]),
        )
      end
    end

    class TestStepFinished

      ##
      # Returns a new TestStepFinished from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TestStepFinished.from_h(some_hash) # => #<Cucumber::Messages::TestStepFinished:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          test_case_started_id: hash[:testCaseStartedId],
          test_step_id: hash[:testStepId],
          test_step_result: TestStepResult.from_h(hash[:testStepResult]),
          timestamp: Timestamp.from_h(hash[:timestamp]),
        )
      end
    end

    class TestStepResult

      ##
      # Returns a new TestStepResult from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TestStepResult.from_h(some_hash) # => #<Cucumber::Messages::TestStepResult:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          duration: Duration.from_h(hash[:duration]),
          message: hash[:message],
          status: hash[:status],
          exception: Exception.from_h(hash[:exception]),
        )
      end
    end

    class TestStepStarted

      ##
      # Returns a new TestStepStarted from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::TestStepStarted.from_h(some_hash) # => #<Cucumber::Messages::TestStepStarted:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          test_case_started_id: hash[:testCaseStartedId],
          test_step_id: hash[:testStepId],
          timestamp: Timestamp.from_h(hash[:timestamp]),
        )
      end
    end

    class Timestamp

      ##
      # Returns a new Timestamp from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::Timestamp.from_h(some_hash) # => #<Cucumber::Messages::Timestamp:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          seconds: hash[:seconds],
          nanos: hash[:nanos],
        )
      end
    end

    class UndefinedParameterType

      ##
      # Returns a new UndefinedParameterType from the given hash.
      # If the hash keys are camelCased, they are properly assigned to the
      # corresponding snake_cased attributes.
      #
      #   Cucumber::Messages::UndefinedParameterType.from_h(some_hash) # => #<Cucumber::Messages::UndefinedParameterType:0x... ...>
      #

      def self.from_h(hash)
        return nil if hash.nil?

        self.new(
          expression: hash[:expression],
          name: hash[:name],
        )
      end
    end
  end
end

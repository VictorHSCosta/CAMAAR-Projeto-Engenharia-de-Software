module LanguageServer
  module Protocol
    module Interface
      #
      # A workspace diagnostic report.
      #
      class WorkspaceDiagnosticReport
        def initialize(items:)
          @attributes = {}

          @attributes[:items] = items

          @attributes.freeze
        end

        # @return [WorkspaceDocumentDiagnosticReport[]]
        def items
          attributes.fetch(:items)
        end

        attr_reader :attributes

        def to_hash
          attributes
        end

        def to_json(*args)
          to_hash.to_json(*args)
        end
      end
    end
  end
end

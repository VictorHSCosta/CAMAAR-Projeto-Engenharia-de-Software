require 'active_support/testing/file_fixtures'

module RSpec
  module Rails
    # @private
    module FileFixtureSupport
      extend ActiveSupport::Concern
      include ActiveSupport::Testing::FileFixtures

      included do
        self.file_fixture_path = RSpec.configuration.file_fixture_path
        if defined?(ActiveStorage::FixtureSet)
          ActiveStorage::FixtureSet.file_fixture_path = RSpec.configuration.file_fixture_path
        end
      end
    end
  end
end

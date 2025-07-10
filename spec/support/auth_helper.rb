# frozen_string_literal: true

# Test helper module to bypass authentication
module TestAuthHelper
  def self.included(base)
    base.class_eval do
      def authenticate_user_test_bypass!
        # Skip authentication in tests
        true
      end

      alias_method :authenticate_user!, :authenticate_user_test_bypass!

      def current_user
        @current_user ||= find_or_create_test_user
      end

      def user_signed_in?
        true
      end

      private

      def find_or_create_test_user
        return @test_user if defined?(@test_user)

        find_existing_admin_user || create_test_admin_user
      end

      def find_existing_admin_user
        existing_admin = User.where(role: :admin).first
        existing_admin || nil
      end

      def create_test_admin_user
        User.new(
          role: :admin,
          email: 'test_admin@example.com',
          matricula: '00000000',
          name: 'Test Admin'
        )
      end
    end
  end
end

# Include in ApplicationController for tests
ApplicationController.include TestAuthHelper if Rails.env.test?

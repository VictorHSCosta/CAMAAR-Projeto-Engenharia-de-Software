# frozen_string_literal: true

# :markup: markdown

require "active_support/core_ext/hash/keys"
require "action_dispatch/middleware/session/abstract_store"
require "rack/session/cookie"

module ActionDispatch
  module Session
    # # Action Dispatch Session CookieStore
    #
    # This cookie-based session store is the Rails default. It is dramatically
    # faster than the alternatives.
    #
    # Sessions typically contain at most a user ID and flash message; both fit
    # within the 4096 bytes cookie size limit. A `CookieOverflow` exception is
    # raised if you attempt to store more than 4096 bytes of data.
    #
    # The cookie jar used for storage is automatically configured to be the best
    # possible option given your application's configuration.
    #
    # Your cookies will be encrypted using your application's `secret_key_base`.
    # This goes a step further than signed cookies in that encrypted cookies cannot
    # be altered or read by users. This is the default starting in Rails 4.
    #
    # Configure your session store in an initializer:
    #
    #     Rails.application.config.session_store :cookie_store, key: '_your_app_session'
    #
    # In the development and test environments your application's `secret_key_base`
    # is generated by Rails and stored in a temporary file in
    # `tmp/local_secret.txt`. In all other environments, it is stored encrypted in
    # the `config/credentials.yml.enc` file.
    #
    # If your application was not updated to Rails 5.2 defaults, the
    # `secret_key_base` will be found in the old `config/secrets.yml` file.
    #
    # Note that changing your `secret_key_base` will invalidate all existing
    # session. Additionally, you should take care to make sure you are not relying
    # on the ability to decode signed cookies generated by your app in external
    # applications or JavaScript before changing it.
    #
    # Because CookieStore extends `Rack::Session::Abstract::Persisted`, many of the
    # options described there can be used to customize the session cookie that is
    # generated. For example:
    #
    #     Rails.application.config.session_store :cookie_store, expire_after: 14.days
    #
    # would set the session cookie to expire automatically 14 days after creation.
    # Other useful options include `:key`, `:secure`, `:httponly`, and `:same_site`.
    class CookieStore < AbstractSecureStore
      class SessionId < DelegateClass(Rack::Session::SessionId)
        attr_reader :cookie_value

        def initialize(session_id, cookie_value = {})
          super(session_id)
          @cookie_value = cookie_value
        end
      end

      DEFAULT_SAME_SITE = proc { |request| request.cookies_same_site_protection } # :nodoc:

      def initialize(app, options = {})
        options[:cookie_only] = true
        options[:same_site] = DEFAULT_SAME_SITE if !options.key?(:same_site)
        super
      end

      def delete_session(req, session_id, options)
        new_sid = generate_sid unless options[:drop]
        # Reset hash and Assign the new session id
        req.set_header("action_dispatch.request.unsigned_session_cookie", new_sid ? { "session_id" => new_sid.public_id } : {})
        new_sid
      end

      def load_session(req)
        stale_session_check! do
          data = unpacked_cookie_data(req)
          data = persistent_session_id!(data)
          [Rack::Session::SessionId.new(data["session_id"]), data]
        end
      end

      private
        def extract_session_id(req)
          stale_session_check! do
            sid = unpacked_cookie_data(req)["session_id"]
            sid && Rack::Session::SessionId.new(sid)
          end
        end

        def unpacked_cookie_data(req)
          req.fetch_header("action_dispatch.request.unsigned_session_cookie") do |k|
            v = stale_session_check! do
              if data = get_cookie(req)
                data.stringify_keys!
              end
              data || {}
            end
            req.set_header k, v
          end
        end

        def persistent_session_id!(data, sid = nil)
          data ||= {}
          data["session_id"] ||= sid || generate_sid.public_id
          data
        end

        def write_session(req, sid, session_data, options)
          session_data["session_id"] = sid.public_id
          SessionId.new(sid, session_data)
        end

        def set_cookie(request, session_id, cookie)
          cookie_jar(request)[@key] = cookie
        end

        def get_cookie(req)
          cookie_jar(req)[@key]
        end

        def cookie_jar(request)
          request.cookie_jar.signed_or_encrypted
        end
    end
  end
end

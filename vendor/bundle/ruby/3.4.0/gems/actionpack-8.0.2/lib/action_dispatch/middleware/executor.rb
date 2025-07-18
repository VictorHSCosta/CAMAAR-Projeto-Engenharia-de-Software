# frozen_string_literal: true

# :markup: markdown

require "rack/body_proxy"

module ActionDispatch
  class Executor
    def initialize(app, executor)
      @app, @executor = app, executor
    end

    def call(env)
      state = @executor.run!(reset: true)
      begin
        response = @app.call(env)

        if env["action_dispatch.report_exception"]
          error = env["action_dispatch.exception"]
          @executor.error_reporter.report(error, handled: false, source: "application.action_dispatch")
        end

        returned = response << ::Rack::BodyProxy.new(response.pop) { state.complete! }
      rescue Exception => error
        request = ActionDispatch::Request.new env
        backtrace_cleaner = request.get_header("action_dispatch.backtrace_cleaner")
        wrapper = ExceptionWrapper.new(backtrace_cleaner, error)
        @executor.error_reporter.report(wrapper.unwrapped_exception, handled: false, source: "application.action_dispatch")
        raise
      ensure
        state.complete! unless returned
      end
    end
  end
end

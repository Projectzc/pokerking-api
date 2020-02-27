module Middlewares
  class Gc
    def initialize app
      @app = app
    end

    def call env
      start = GC.stat[:heap_live_slots]
      Rails.logger.info "GC before: #{start}"

      status, header, response = @app.call(env)
      Rails.logger.info "GC after: #{GC.stat[:heap_live_slots]}, growth: #{GC.stat[:heap_live_slots] - start}"

      [status, header, response]
    end
  end
end
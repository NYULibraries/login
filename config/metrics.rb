require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

module Prometheus::Middleware
  class CollectorWithExclusions < Collector
    def initialize(app, options = {})
      @exclude = EXCLUDE
      options[:counter_label_builder] = SHARED_CUSTOM_LABEL_BUILDER
      options[:duration_label_builder] = SHARED_CUSTOM_LABEL_BUILDER
      options[:metrics_prefix] = ENV['PROMETHEUS_METRICS_PREFIX']

      super(app, options)   
    end

    def call(env)
      if @exclude && @exclude.call(env)
        @app.call(env)
      else
        super(env)
      end
    end

  protected

    EXCLUDE = proc do |env|
      (!!env['PATH_INFO'].match(%r{^(/search)?/(metrics|healthcheck)}))
    end

    SHARED_CUSTOM_LABEL_BUILDER = proc do |env, code|
      {
        code:         code,
        is_error_code: code.match?(/^(4|5)..$/).to_s, 
        method:       env['REQUEST_METHOD'].downcase,
        host:         env['HTTP_HOST'].to_s,
        path:         env['PATH_INFO'].to_s,
        app:          "login"
      }
    end

  end
end


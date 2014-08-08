module Login
  module Aleph
    module XService
      class Base
        attr_accessor :host, :port, :path

        def initialize(host = ENV["ALEPH_XSERVICE_HOST"], port = ENV["ALEPH_XSERVICE_PORT"], path = ENV["ALEPH_XSERVICE_PATH"])
          @host = host
          @port = port
          @path = path
        end

        def response
          @response ||= connection.get "#{path}?#{querystring}"
        end

      protected

        def options
          @options ||= {
            op: op,
            bor_id: identifier,
            library: library
          }
        end

        def querystring
          @querystring ||= options.to_query
        end

        def op
          raise ArgumentError.new "Expected child to implement this function!"
        end

      private

        def connection
          @connection ||= Faraday.new(:url => "#{host}:#{port}") do |faraday|
            faraday.response :xml,  :content_type => /\bxml$/
            faraday.request  :url_encoded
            faraday.response :logger
            faraday.adapter Faraday.default_adapter
          end
        end

      end
    end
  end
end

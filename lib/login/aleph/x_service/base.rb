module Login
  module Aleph
    module XService
      class Base
        attr_accessor :host, :port, :path, :library, :sub_library

        def initialize
          @port = ENV["ALEPH_X_PORT"]
          @host = (port == "443") ? "https://#{ENV["ALEPH_HOST"]}" : "http://#{ENV["ALEPH_HOST"]}"
          @path = ENV["ALEPH_X_PATH"]
          @library = ENV["ALEPH_LIBRARY"]
          @sub_library = ENV["ALEPH_SUB_LIBRARY"]
        end

        def response
          @response ||= connection.get "#{path}?#{querystring}"
        end

        def error
          @error ||= response.body[op]["error"]
        end

        def error?
          error.present?
        end

      protected

        def options
          @options ||= {
            op: op,
            bor_id: identifier,
            library: library,
            sub_library: sub_library
          }
        end

        def querystring
          @querystring ||= options.to_query
        end

        def op
          raise RuntimeError, "Expected this to be implemented in a subclass!"
        end

        def identifier
          raise RuntimeError, "Expected this to be implemented in a subclass!"
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

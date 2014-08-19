module Login
  module Aleph
    module XService
      class Base
        attr_accessor :host, :port, :path, :library, :sub_library

        def initialize(host = ENV["ALEPH_HOST"], port = ENV["ALEPH_X_PORT"], path = ENV["ALEPH_X_PATH"], library = ENV["ALEPH_LIBRARY"], sub_library = ENV["ALEPH_SUB_LIBRARY"])
          @port = (port || "80")
          @host = (port == "443") ? "https://#{host}" : "http://#{host}"
          @path = (path || "/X")
          @library = library
          @sub_library = (sub_library || library)
        end

        def response
          @response ||= connection.get "#{path}?#{querystring}"
        end

        def error
          @error ||= begin
            response.body[op]["error"]
          rescue NoMethodError => e
            response.body["login"]["error"]
          end
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

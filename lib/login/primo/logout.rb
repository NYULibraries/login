module Login
  module Primo
    class Logout
      SERVER_MAP = {
        "bobcatdev.library.nyu.edu:80/primo_library" => ["primodev1.bobst.nyu.edu/primo_library", "primodev2.bobst.nyu.edu/primo_library"],
        "bobcat.library.nyu.edu:80/primo_library" => ["primo1.bobst.nyu.edu/primo_library", "primo2.bobst.nyu.edu/primo_library"]
      }
      attr_accessor :bobcat_url, :pds_handle, :hosts

      def initialize(bobcat_url, pds_handle)
        raise ArgumentError, 'bobcat_url cannot be nil' if bobcat_url.nil?
        raise ArgumentError, 'pds_handle cannot be nil' if pds_handle.nil?
        @bobcat_url = bobcat_url
        @pds_handle = pds_handle
        begin
          @hosts = SERVER_MAP[@bobcat_url]
        rescue
          raise ArgumentError, 'Missing host definition'
        end
      end

      def logout!(failures = Array.new)
        @hosts.each do |host|
          response = Faraday.get logout_url
          failures << logout_url unless response.success?
        end
        unless failures.empty?
          true
        else
          raise RuntimeError, "Not all hosts successful. Failed host(s): #{failures.join(',')}"
        end
      end

    private

      def logout_url
        @logout_url ||= "http://#{host}/libweb/ssoLogout?pdsHandle=#{pds_handle}"
      end

    end
  end
end

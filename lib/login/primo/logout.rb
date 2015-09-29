##
# Hack to deal with 2 problem
#		1. Call to load balanced URL doesn't kill Primo
#			session unless it happens to hit the same server.
#			(Ex Libris problem)
#		2. Call from PDS server to itself refuses connection,
#			so we can't make the call from the same server.
#			(NYU load balancer problem)
module Login
  module Primo
    class Logout
      SERVER_MAP = {
        "http://bobcatdev.library.nyu.edu" => ["primodev1.bobst.nyu.edu/primo_library", "primodev2.bobst.nyu.edu/primo_library"],
        "http://bobcat.library.nyu.edu" => ["primo1.bobst.nyu.edu/primo_library", "primo2.bobst.nyu.edu/primo_library"]
      }
      attr_accessor :bobcat_url, :pds_handle, :hosts

      def initialize(bobcat_url, pds_handle)
        raise ArgumentError, 'bobcat_url cannot be nil' if bobcat_url.nil?
        @bobcat_url = bobcat_url
        @pds_handle = pds_handle # Not required because it may not exist
        @hosts = SERVER_MAP[@bobcat_url]
        raise ArgumentError, 'Missing host definition' if hosts.nil?
      end

      # Loop through Primo hosts and call logout on all
      def logout!(failures = Array.new)
        hosts.each do |host|
          logout_url = logout_url(host, pds_handle)
          response = Faraday.get logout_url
          failures << "ERROR #{response.status}: #{logout_url}" unless response.success?
        end
        unless failures.empty?
          raise RuntimeError, "Not all hosts successful. Failed host(s): #{failures.join('; ')}"
        else
          true
        end
      end

    private

      # Call Primo ssoLogout script to handle logging out of load balanced machines
      def logout_url(host, pds_handle)
        "http://#{host}/libweb/ssoLogout?pdsHandle=#{pds_handle}"
      end

    end
  end
end

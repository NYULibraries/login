module LoginFeatures
  module Locations
    def first_ip_for_institute(institute)
      ip_addresses = ::Institutions.institutions[institute.to_sym].ip_addresses
      if ip_addresses.present?
        first_ip_address = ip_addresses.send(:segments).first
        if first_ip_address.is_a?(::IPAddr)
          first_ip_address = first_ip_address.to_range
        end
        if first_ip_address.is_a?(::Range)
          first_ip_address = first_ip_address.first
        end
        first_ip_address.to_s
      end
    end

    def ip_for_location(location)
      first_ip_for_institute(institute_for_location(location))
    end

    def username_for_location(location)
      ENV["TEST_#{institute_for_location(location)}_USERNAME"]
    end

    def password_for_location(location)
      ENV["TEST_#{institute_for_location(location)}_PASSWORD"]
    end

    def institute_for_location(location)
      case location
      when /NYU (.+)$/
        case $1
        when /New York/
          :NYU
        when /Abu Dhabi/
          :NYUAD
        when /Shanghai/
          :NYUSH
        when /Health Sciences/
          :HSL
        end
      when /New School/
        :NS
      when /Cooper Union/
        :CU
      when /NYSID/
        :NYSID
      when /Twitter/
        :TWITTER
      when /Bobst Affiliate/
        :BOBST
      else
        raise "Unknown location!"
      end
    end

    def visit_login_page_for(location)
      visit login_path(institute_for_location(location).downcase)
    end

    def expect_login_page_for(location)
      expect(current_path).to eq(login_path(institute_for_location(location).downcase))
    end
  end
end

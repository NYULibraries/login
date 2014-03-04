module LoginFeatures
  module Institutions
    def first_ip_for_institute(institute)
      ip_addresses = ::Institutions.institutions[institute.to_sym].ip_addresses
      ip_addresses.first if ip_addresses.present?
    end

    def ip_for_location(location)
      first_ip_for_institute(institute_for_location(location))
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
      else
        raise "Unknown location!"
      end
    end
  end
end

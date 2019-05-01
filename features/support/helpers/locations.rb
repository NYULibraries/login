module LoginFeatures
  module Locations
    include NyulibrariesInstitutions::InstitutionHelper
    def first_ip_for_institution(institution)
      ip_addresses = institutions[institution.to_sym].ip_addresses
      if ip_addresses.present?
        first_ip_address = ip_addresses.send(:segments).first
        if first_ip_address.is_a? Range
          first_ip_address.first.to_s
        elsif first_ip_address.is_a? IPAddr
          first_ip_address.to_s
        end
      end
    end

    def ip_for_location(location)
      first_ip_for_institution(institution_for_location(location))
    end

    def username_for_location(location)
      # Defaults out to 'auth_key' for CI 
      ENV.fetch(username_for(location), "username")
    end

    def password_for_location(location)
      # Defaults out to 'auth_key' for CI 
      ENV.fetch(password_for(location), "auth_key")
    end

    def username_for(location)
      "TEST_#{institution_for_location(location)}_USERNAME"
    end

    def password_for(location)
      "TEST_#{institution_for_location(location)}_PASSWORD"
    end

    def institution_for_location(location)
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
      when /Other Borrower/
        :BOBST
      when /Visitors/
        :VISITOR
      else
        raise "Unknown location!"
      end
    end

    def visit_login_page_for_location(location, params = {})
      visit login_path(institution_for_location(location).downcase, params)
    end

    def expect_login_page_for_location(location)
      expect(current_path).to eq(login_path(institution_for_location(location).downcase))
    end

    def set_login_env_for_location(location)
      case location
      when /New School LDAP$/
        set_new_school_ldap_login_env
      when /NYU Shibboleth$/
        set_nyu_shibboleth_login_env
      when /Aleph$/
        set_aleph_login_env
      when /Twitter$/
        set_twitter_login_env
      else
        raise "Unknown location!"
      end
    end

    def follow_login_steps_for_location(location)
      case location
      when /New School LDAP$/
        click_on "The New School"
        click_button "Login"
      when /NYU Shibboleth$/
        click_on "NYU"
      when /Aleph$/
        click_on "Other Borrowers"
        click_button "Login"
      when /Twitter$/
        click_on "Visitors"
        click_on "Twitter"
      else
        raise "Unknown location!"
      end
    end

    def provider_to_location
      {
        "twitter" => "Twitter",
        "nyu_shibboleth" => "NYU Shibboleth"
      }
    end
  end
end

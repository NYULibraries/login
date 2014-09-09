module LoginFeatures
  module PageMatchers
    def expectations_for_page(page, negator, *matchers)
      expectation_verb = (negator.present?) ? :not_to : :to
      matchers.each do |matcher|
        expect(page).send(expectation_verb, matcher.call)
      end
    end

    def error_matchers(message)
      @error_matchers ||= [
        -> { have_css "div.alert.alert-error"},
        -> { have_content message }
      ]
    end

    def shib_login_matchers
      @shib_login_matchers ||= [
        -> { have_content 'Login to' },
        -> { have_content 'NYU Login' },
        -> { have_css '#login label[for="username"]' },
        -> { have_css '#login #netid' },
        -> { have_css '#login label[for="password"]' },
        -> { have_css '#login #password' },
        -> { have_css '#login input[type="submit"][value="Login"]' }
      ]
    end

    def nyu_login_matchers
      @nyu_login_matchers ||= [
        -> { have_css '#nyu_shibboleth-login' },
        -> { have_xpath '//div[@id="nyu_shibboleth-login"]'}
      ]
    end

    def nyu_style_matchers
      @nyu_style_matches ||= [
        -> { have_content 'NYU Libraries' },
        -> { have_link('NYU Libraries', {:href => 'http://library.nyu.edu'}) }
      ]
    end

    def ns_login_matchers
      @ns_login_matchers ||= [
        -> { have_content 'Login with a New School NetID' },
        -> { have_content 'Enter your NetID Username' },
        -> { have_content 'Enter your NetID Password' }
      ]
    end

    def cu_login_matchers
      @cu_login_matchers ||= [
        -> { have_content 'Login with your Cooper Union patron ID' },
        -> { have_content 'Enter your ID Number' },
        -> { have_content 'First four letter of your last name' }
      ]
    end

    def nysid_login_matchers
      @nysid_login_matchers ||= [
        -> { have_content 'Login with your NYSID patron ID' },
        -> { have_content 'Enter your ID Number' },
        -> { have_content 'First four letter of your last name' }
      ]
    end

    def nyu_option_matchers
      @nyu_option_matchers ||= [
        -> { have_content 'NYU' },
        -> { have_css '.nyu.alt-login' }
      ]
    end

    def ns_option_matchers
      @ns_option_matchers ||= [
        -> { have_content 'The New School' },
        -> { have_css '.ns.alt-login' }
      ]
    end

    def cu_option_matchers
      @cu_option_matchers ||= [
        -> { have_content 'Cooper Union' },
        -> { have_css '.cu.alt-login' }
      ]
    end

    def nysid_option_matchers
      @nysid_option_matchers ||= [
        -> { have_content 'NYSID' },
        -> { have_css '.nysid.alt-login' }
      ]
    end

    def bobst_option_matchers
      @bobst_option_matchers ||= [
        -> { have_content "Other Borrowers" },
        -> { have_css '.bobst.alt-login' }
      ]
    end

    def facebook_option_matchers
      @facebook_option_matchers ||= [
        -> { have_content 'Visitors' },
        -> { have_css '.facebook.alt-login' }
      ]
    end

    def twitter_option_matchers
      @twitter_option_matchers ||= [
        -> { have_content 'Visitors' },
        -> { have_css '.twitter.alt-login' }
      ]
    end

    def twitter_style_matchers
      @twitter_style_matchers ||= [
        -> { have_content 'Authorize NYU Libraries to use your account?' },
        -> { have_css '#oauth_form #username_or_email' },
        -> { have_css '#oauth_form #allow' },
      ]
    end

    def facebook_style_matchers
      @facebook_style_matchers ||= [
        -> { have_content 'Facebook Login' },
        -> { have_field 'email' },
        -> { have_field 'pass' },
      ]
    end

    def logged_in_matchers(location)
      @logged_in_matchers ||= [
        -> { have_content 'Successfully authenticated ' },
        -> { have_content "Hi #{username_for_location(location)}!" },
        -> { have_content 'You logged in via' },
        -> { have_content " you've logged in to the NYU Libraries' services." }
      ]
    end

    def newschool_logged_in_matchers
      @logged_in_matchers ||= [
        -> { have_content 'Successfully authenticated from your New School Ldap account' },
        -> { have_content "Hi" },
        -> { have_content 'You logged in via New School Ldap' },
        -> { have_content " you've logged in to the NYU Libraries' services." }
      ]
    end

    def aleph_logged_in_matchers(location)
      @logged_in_matchers ||= [
        -> { have_content 'Successfully authenticated ' },
        -> { have_content "Hi " },
        -> { have_content 'You logged in via' },
        -> { have_content " you've logged in to the NYU Libraries' services." }
      ]
    end

    def mismatched_aleph_credentials_matchers()
      @mismatched_credentials_matchers ||= [
        -> { have_content 'Could not authenticate you from Aleph because "Error in verification".' }
      ]
    end

    def shibboleth_logged_in_matchers(institute)
      @logged_in_matchers ||= [
        -> { have_content 'Successfully authenticated ' },
        -> { have_content "Hi #{nyu_shibboleth_username_for_institute(institute)}!" },
        -> { have_content 'You logged in via' },
        -> { have_content " you've logged in to the NYU Libraries' services." }
      ]
    end

    def authorize_applications_matchers
      @authorize_applications_matchers ||= [
        -> { have_css(".brand") },
        -> { have_text("OAuth2 Provider") },
        -> { have_text("Your applications") },
        -> { have_text("New Application") },
        -> { have_css(".zebra-striped") }
      ]
    end
  end
end

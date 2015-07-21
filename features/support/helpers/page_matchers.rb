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
        -> { have_css "div.alert.alert-danger"},
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
        -> { have_content 'Enter your NetID' },
        -> { have_content 'Enter your password' },
        -> { have_link("Ask a Librarian", { href: "http://answers.library.newschool.edu"}) }
      ]
    end

    def cu_login_matchers
      @cu_login_matchers ||= [
        -> { have_content 'Login with your Cooper Union patron ID' },
        -> { have_content 'Enter your ID Number' },
        -> { have_content 'First four letters of your last name' },
        -> { have_link("Get help from a librarian.", { href: "http://library.cooper.edu/library_information_frameset.html"}) }
      ]
    end

    def nysid_login_matchers
      @nysid_login_matchers ||= [
        -> { have_content 'Login with your NYSID ID number' },
        -> { have_selector("input[placeholder='e.g. 123456']") },
        -> { have_content 'Enter your ID Number' },
        -> { have_content 'First four letters of your last name' },
        -> { have_link("Ask a Librarian", { href: "http://library.nysid.edu/library/about-the-library/contact-us/"}) }
      ]
    end

    def bobst_login_matchers
      @bobst_login_matchers ||= [
        -> { have_content 'Login with your library card number' },
        -> { have_content 'Enter your library card number' },
        -> { have_no_content 'e.g.' },
        -> { have_content 'First four letters of your last name' }
      ]
    end

    def nyuad_other_borrower_matchers
      @nyuad_other_borrower_matchers ||= [
        -> { have_content 'Login with your NYU Abu Dhabi Library card number' },
        -> { have_content 'Enter your library card number' },
        -> { have_no_content 'e.g.' },
        -> { have_content 'First four letters of your last name' }
      ]
    end

    def nyush_other_borrower_matchers
      @nyush_other_borrower_matchers ||= [
        -> { have_content 'Login with your library card number' },
        -> { have_content 'Enter your library card number' },
        -> { have_no_content 'e.g.' },
        -> { have_content 'First four letters of your last name' }
      ]
    end

    def twitter_login_matchers
      @twitter_login_matchers ||= [
        -> { have_content 'Twitter' },
        -> { have_css '#twitter-login' },
      ]
    end

    def facebook_login_matchers
      @facebook_login_matchers ||= [
        -> { have_content 'Facebook' },
        -> { have_css '#facebook-login' },
      ]
    end

    def nyu_option_matchers
      @nyu_option_matchers ||= [
        -> { have_content 'NYU' },
        -> { have_css '#nyu_shibboleth-login' }
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

    def visitor_option_matchers
      @visitor_option_matchers ||= [
        -> { have_content 'Visitors' },
        -> { have_css '#visitor-login' }
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
        -> { have_content "Hi #{username_for_location(location)}!" },
        -> { have_content 'You logged in via' },
        -> { have_content " you've logged in to the NYU Libraries' services." }
      ]
    end

    def newschool_logged_in_matchers
      @logged_in_matchers ||= [
        -> { have_content "Hi" },
        -> { have_content 'You logged in via New School Ldap' },
        -> { have_content " you've logged in to the NYU Libraries' services." }
      ]
    end

    def aleph_logged_in_matchers(location)
      @logged_in_matchers ||= [
        -> { have_content "Hi " },
        -> { have_content 'You logged in via' },
        -> { have_content " you've logged in to the NYU Libraries' services." }
      ]
    end

    def mismatched_aleph_credentials_matchers()
      @mismatched_credentials_matchers ||= [
        -> { have_content 'Something went wrong' },
        -> { have_content 'You may have entered your information incorrectly or you do not have access to this resource' }
      ]
    end

    def shibboleth_logged_in_matchers(institution)
      @logged_in_matchers ||= [
        -> { have_content "Hi #{nyu_shibboleth_username_for_institution(institution)}!" },
        -> { have_content 'You logged in via' },
        -> { have_content " you've logged in to the NYU Libraries' services." }
      ]
    end

    def authorize_applications_matchers
      @authorize_applications_matchers ||= [
        -> { have_css(".navbar-brand") },
        -> { have_text("OAuth2 Provider") },
        -> { have_text("Your applications") },
        -> { have_text("New Application") }
      ]
    end

    def nyu_logout_matchers
      @nyu_logout_matchers ||= [
        -> { have_content 'LOGGED OUT' }
      ]
    end

    def ns_logout_matchers
      @ns_logout_matchers ||= [
        -> { have_link('New School Libraries', {:href => 'http://library.newschool.edu'}) },
        -> { have_content 'LOGGED OUT' }
      ]
    end

    def cu_logout_matchers
      @cu_logout_matchers ||= [
        -> { have_link('Cooper Union Library', {:href => 'http://library.cooper.edu'}) },
        -> { have_content 'LOGGED OUT' }
      ]
    end

    def nysid_logout_matchers
      @nysid_logout_matchers ||= [
        -> { have_link('New York School of Interior Design Library', {:href => 'http://library.nysid.edu/library'}) },
        -> { have_content 'LOGGED OUT' }
      ]
    end

  end
end

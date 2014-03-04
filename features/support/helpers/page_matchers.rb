module LoginFeatures
  module PageMatchers
    def expectations_for_page(page, negator, *matchers)
      expectation_verb = (negator.present?) ? :not_to : :to
      matchers.each do |matcher|
        expect(page).send(expectation_verb, matcher.call)
      end
    end

    def nyu_login_matchers
      @nyu_login_matchers ||= [
        -> { have_content 'Login with an NYU NetID' },
        -> { have_css '#shibboleth .btn' }
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
        -> { have_content 'NYU Libraries' },
        -> { have_css '.nyu.alt-login' }
      ]
    end

    def ns_option_matchers
      @ns_option_matchers ||= [
        -> { have_content 'New School Libraries' },
        -> { have_css '.ns.alt-login' }
      ]
    end

    def cu_option_matchers
      @cu_option_matchers ||= [
        -> { have_content 'The Cooper Union Library' },
        -> { have_css '.cu.alt-login' }
      ]
    end

    def nysid_option_matchers
      @nysid_option_matchers ||= [
        -> { have_content 'New York School of Interior Design' },
        -> { have_css '.nysid.alt-login' }
      ]
    end

    def bobst_option_matchers
      @bobst_option_matchers ||= [
        -> { have_content "NYU Libraries' Affiliates" },
        -> { have_css '.bobst.alt-login' }
      ]
    end

    def facebook_option_matchers
      @facebook_option_matchers ||= [
        -> { have_content 'Facebook' },
        -> { have_css '.facebook.alt-login' }
      ]
    end

    def twitter_option_matchers
      @twitter_option_matchers ||= [
        -> { have_content 'Twitter' },
        -> { have_css '.twitter.alt-login' }
      ]
    end
  end
end

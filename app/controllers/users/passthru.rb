module Users
  module Passthru
    ESHELF_COOKIE_NAME = '_nyulibraries_eshelf_passthru'

    # GET /passthru
    # Redirect to original stored location after being sent back to the Login app
    # from the eshelf login
    def passthru
      # Assuming we authenticated in E-shelf
      # Return to the original location, on active login
      # or back to the passive login action, on passive
      action_before_eshelf_redirect = session[:_action_before_eshelf_redirect]
      session[:_action_before_eshelf_redirect] = nil
      cookies.delete(ESHELF_COOKIE_NAME, domain: ENV['LOGIN_COOKIE_DOMAIN'])
      puts "redirect_to stored_location_for(:user): #{stored_location_for(:user)}"
      puts "action_before_eshelf_redirect: #{action_before_eshelf_redirect}"
      puts "signed_in_root_path(:user): #{signed_in_root_path(:user)}"
      redirect_to stored_location_for(:user) || action_before_eshelf_redirect || signed_in_root_path(:user)
    end

    def after_sign_in_path_for(resource)
      # If there is an eshelf login variable set then we want to redirect there after login
      # to permanently save eshelf records
      if ENV['ESHELF_LOGIN_URL'] && !cookies[ESHELF_COOKIE_NAME]
        session[:_action_before_eshelf_redirect] = (stored_location_for(resource) || request.env['omniauth.origin'])
        create_eshelf_cookie!
        return ENV['ESHELF_LOGIN_URL']
      else
        super(resource)
      end
    end

    private

    def create_eshelf_cookie!
      cookie_hash = { value: 1, httponly: true, domain: ENV['LOGIN_COOKIE_DOMAIN'] }
      cookies[ESHELF_COOKIE_NAME] = cookie_hash
    end
  end
end

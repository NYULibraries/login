module Users
  class PassthruController < Devise::OmniauthCallbacksController
    before_action :authenticate_user!

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

      # DEBUGGING TO SEE HOW COOKIES ARE PERSISTED
      cookie_hash = { value: action_before_eshelf_redirect, httponly: true, domain: ENV['LOGIN_COOKIE_DOMAIN'] }
      cookies['_login_test_cookie_passthru'] = cookie_hash

      redirect_to stored_location_for(:user) || action_before_eshelf_redirect || signed_in_root_path(:user)
    end
  end
end

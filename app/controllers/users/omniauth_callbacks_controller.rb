module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :require_valid_omniauth_hash!,
                  only: [*Devise.omniauth_providers, :omniauth_callback]

    LOGGED_IN_COOKIE_NAME = '_nyulibraries_logged_in'.freeze

    def after_omniauth_failure_path_for(scope)
      flash[:alert] = t('devise.users.user.failure', ask: t("application.#{params[:auth_type]}.ask_a_librarian")).html_safe
      # When using the auth_type nyu, for Shibboleth, redirect errors to the wayf page
      if params[:auth_type] == "nyu" || !params[:auth_type]
        login_path(current_institution.code.downcase)
      # When on any authentication page redirect errors there
      else
        auth_path(current_institution.code.downcase, auth_type: params[:auth_type])
      end
    end

    def omniauth_callback
      @user = User.find_for_authentication_or_initialize_by(
        username: omniauth_hash_map.username,
        provider: omniauth_hash_map.provider
      )
      # Initialize with an email address if the omniauth hash has it.
      @user.email = omniauth_hash_map.email if @user.email.blank? && omniauth_hash_map.email.present?
      # Set the OmniAuth::AuthHash for the user
      @user.omniauth_hash_map = omniauth_hash_map
      @user.institution_code = omniauth_hash_map.properties.institution_code.to_s unless omniauth_hash_map.properties.institution_code.nil?
      if @user.save
        create_loggedin_cookie!(@user)
        sign_in_and_redirect @user, event: :authentication
        kind = omniauth_hash_map.provider.titleize
        set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
      else
        redirect_to after_omniauth_failure_path_for(resource_name)
      end
    end

    Devise.omniauth_providers.each do |omniauth_provider|
      alias_method omniauth_provider, :omniauth_callback
    end

    private

    def omniauth_hash_map
      @omniauth_hash_map ||= Login::OmniAuthHash::Mapper.new(request.env["omniauth.auth"])
    end

    def omniauth_hash_validator
      @omniauth_hash_validator ||= Login::OmniAuthHash::Validator.new(request.env["omniauth.auth"], params[:action])
    end

    # Create a session cookie shared with other logged in clients
    # so they can key single sign off indivudally
    def create_loggedin_cookie!(user)
      cookie_hash = { value: 1, httponly: true, domain: ENV['LOGIN_COOKIE_DOMAIN'] }
      cookies[LOGGED_IN_COOKIE_NAME] = cookie_hash
    end

    def require_valid_omniauth_hash!
      redirect_to after_omniauth_failure_path_for(resource_name) unless omniauth_hash_validator.valid?
    end
  end
end

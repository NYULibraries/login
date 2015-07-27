class UsersController < Devise::OmniauthCallbacksController

  include Users::PassiveLogin
  prepend_before_filter :check_passive_shibboleth_and_sign_in, only: [:show, :check_passive_and_sign_client_in], unless: -> { user_signed_in? || Rails.env.development? }
  prepend_before_filter :redirect_root, only: [:show], if: -> { request.path == '/' && user_signed_in? }
  before_filter :require_login, only: [:show]
  before_filter :require_no_authentication, except: [:show, :check_passive_and_sign_client_in]
  before_filter :require_valid_omniauth_hash, only: (Devise.omniauth_providers << :omniauth_callback)
  respond_to :html

  def show
    @user = User.find_by(username: params[:id], provider: params[:provider])
    if @user == current_user
      respond_with(@user)
    else
      redirect_to user_url(current_user)
    end
  end

  def passthru
    if user_signed_in?
      cookies.delete(:_nyulibraries_eshelf_passthru)
      redirect_to (stored_location_for('user') || signed_in_root_path('user'))
    end
    head :bad_request
  end

  def after_sign_in_path_for(resource)
    # If the provided redirect_to param is valid, that is, it redirects to
    # a local URI and not an external URI, it will redirect to that URI.
    if redirect_to_uri_is_valid?
      store_location_for(resource, whitelisted_redirect_to_uri)
    end
    if ENV['ESHELF_LOGIN_URL']
      create_eshelf_cookie!
      return ENV['ESHELF_LOGIN_URL']
    else
      super(resource)
    end
  end

  def check_passive_shibboleth_and_sign_in
    # The flow of logic is as follows:
    # If a Shibboleth session is found, then that means the user must be logged
    # into Shibboleth. Thus, the user is then redirected to the login path for
    # NYU Shibboleth, but with a return_to parameter set so that they can come
    # back to this URI and continue their request after being signed in.
    if shib_session_exists?
      redirect_to nyu_shibboleth_omniauth_authorize_path and return
    end
    # However if the Shibboleth session does not exist, then we check to see
    # if this is the first time they've come to this app. If it is, we have to
    # check with Shibboleth if they are logged in, so we use a cookie to mark
    # that they've been here, then redirect to Shibboleth's passive login check
    # with the return URI set to the current URI, so they can continue their
    # request after being signed in.
    if !cookies[:_check_passive_shibboleth]
      cookies[:_check_passive_shibboleth] = true
      redirect_to passive_shibboleth_url
    end
  end

  def check_passive_and_sign_client_in
    # If the user is signed, and the client is on the whitelist, we can safely
    # log them into the client.
    if user_signed_in? && whitelisted_client
      redirect_to whitelisted_client_login_uri.to_s and return
    end
    # If the user is not signed in, or if the client can't be foudn,
    # we can redirect them to the return_uri they provided, but only
    # if the return URI is whitelisted as well
    if return_uri_validated?
      redirect_to return_uri.to_s and return
    end
    # If none of the above conditions are met, this is just a bad request.
    return head(:bad_request)
  end

  def after_omniauth_failure_path_for(scope)
    flash[:alert] = t('devise.users.user.failure', ask: t("application.#{params[:auth_type]}.ask_a_librarian")).html_safe
    # When using the auth_type nyu, for Shibboleth, redirect errors to the wayf page
    if params[:auth_type] == "nyu"
      login_path(current_institution.code.downcase)
    # When on any authentication page redirect errors there
    else
      auth_path(current_institution.code.downcase, auth_type: params[:auth_type])
    end
  end

  def omniauth_callback
    @user = find_for_authentication(omniauth_hash_map.username, omniauth_hash_map.provider)
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

  # Use Devise::Models::Authenticatable::ClassMethods#find_for_authentication
  # to take advantage of the Devise case_insensitive_keys and treat USER and user as the same username
  def find_for_authentication(username, provider)
    User.find_for_authentication(username: username, provider: provider) || User.find_or_initialize_by(username: username, provider: provider)
  end
  private :find_for_authentication

  def require_login
    unless user_signed_in?
      redirect_to login_url
    end
  end
  private :require_login

  def require_valid_omniauth_hash
    redirect_to after_omniauth_failure_path_for(resource_name) unless omniauth_hash_validator.valid?
  end
  private :require_valid_omniauth_hash

  def omniauth_hash_map
    @omniauth_hash_map ||= Login::OmniAuthHash::Mapper.new(request.env["omniauth.auth"])
  end
  private :omniauth_hash_map

  def omniauth_hash_validator
    @omniauth_hash_validator ||= Login::OmniAuthHash::Validator.new(request.env["omniauth.auth"], params[:action])
  end
  private :omniauth_hash_validator

  # Create a session cookie shared with other logged in clients
  # so they can key single sign off indivudally
  def create_loggedin_cookie!(user)
    cookie_hash = { value: 1, httponly: true, domain: ENV['LOGIN_COOKIE_COMAIN'] }
    cookies[LOGGED_IN_COOKIE_NAME] = cookie_hash
  end
  private :create_loggedin_cookie!

  def create_eshelf_cookie!
    cookie_hash = { value: 1, httponly: true, domain: ENV['LOGIN_COOKIE_COMAIN'] }
    cookies[ESHELF_COOKIE_NAME] = cookie_hash
  end
  private :create_eshelf_cookie!

  def redirect_root
    redirect_to root_url_redirect
  end
  private :redirect_root

  def root_url_redirect
    @root_url_redirect ||= (Figs.env.root_url_redirect) ? Figs.env.root_url_redirect : t('application.root_url_redirect')
  end
  private :root_url_redirect

end

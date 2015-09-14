class UsersController < Devise::OmniauthCallbacksController
  prepend_before_filter :shibboleth_passive_login_check, only: [:client_passive_login]
  prepend_before_filter :save_return_uri
  prepend_before_filter :redirect_root, only: [:show], if: -> { request.path == '/' && user_signed_in? }
  before_filter :require_login, only: [:show]
  before_filter :require_no_authentication, except: [:passthru, :show, :client_passive_login]
  before_filter :require_valid_omniauth_hash, only: (Devise.omniauth_providers << :omniauth_callback)
  skip_before_filter :verify_authenticity_token, only: [:passthru]
  respond_to :html

  def show
    @user = User.find_by(username: params[:id], provider: params[:provider])
    if @user == current_user
      respond_with(@user)
    else
      redirect_to user_url(current_user)
    end
  end

  # GET /login/passive
  # Log client in if SP is logged in
  # otherwise pass back to original uri
  def client_passive_login
    return_uri = session[:_return_uri]
    session[:_return_uri] = nil
    client_app = client_app(params[:client_id])
    login_path = params[:login_path] || '/users/auth/nyulibraries'
    # If user is signed in
    # redirect to client login
    if user_signed_in? && client_app.present?
      client_authorize_url = URI.join(URI.parse(client_app.redirect_uri), login_path, "?origin=#{CGI::escape(return_uri)}")
      redirect_to "#{client_authorize_url}"
    # If the user is not signed in but there is a return URI
    # send the user back there
    elsif return_uri.present?
      redirect_to return_uri
    else
      head :bad_request
    end
  end

  # Interrupt and send user out to passively login,
  # if the Idp has a session
  def shibboleth_passive_login_check
    unless user_signed_in? || session[:_check_passive_shibboleth]
      session[:_check_passive_shibboleth] = true
      # Set the redirect to a callback function that we'll handle
      target_url = "#{CGI::escape("#{passive_shibboleth_url}?origin=#{CGI::escape(request.url)}")}"
      redirect_to "#{PASSIVE_SHIBBOLETH_URL_STRING}#{target_url}"
    end
  end
  private :shibboleth_passive_login_check

  # GET /login/passive_shibboleth
  # Callback function for passive shibboleth
  def shibboleth_passive_login
    # This is the original action called
    # before checking if we were logged in
    origin = params[:origin] if params[:origin]
    # If there is a session, authenticate the user
    if shib_session_exists?
      redirect_to user_omniauth_authorize_path(:nyu_shibboleth, institute: current_institute.code, auth_type: :nyu, origin: origin)
    # If there is no session, redirect back to the last action
    else
      redirect_to origin || root_url
    end
  end

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
    redirect_to stored_location_for("user") || action_before_eshelf_redirect || signed_in_root_path('user')
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
    cookie_hash = { value: 1, httponly: true, domain: ENV['LOGIN_COOKIE_DOMAIN'] }
    cookies[LOGGED_IN_COOKIE_NAME] = cookie_hash
  end
  private :create_loggedin_cookie!

  def create_eshelf_cookie!
    cookie_hash = { value: 1, httponly: true, domain: ENV['LOGIN_COOKIE_DOMAIN'] }
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

  # Check if the shibboleth session has been started
  # based off cookie pattern. This is a weak check as it can be
  # spoofed but if it was an we try to authenticate the error will
  # be raised then
  def shib_session_exists?
    !cookies.detect {|key, val| key.include? SHIBBOLETH_COOKIE_PATTERN }.nil?
  end
  private :shib_session_exists?

  # Get the client app based on the passed in client_id param
  def client_app(client_id)
    client_app = Doorkeeper::Application.all.find do |app|
      app.uid == client_id
    end
    return client_app
  end
  private :client_app

  # Save the return uri if it exists
  def save_return_uri
    session[:_return_uri] = params[:return_uri] if whitelisted_return_uri?
  end
  private :save_return_uri

  def whitelisted_return_uri?
    (params[:return_uri].present? &&
      params[:client_id].present? &&
        (URI::parse(client_app(params[:client_id]).redirect_uri).host == URI::parse(params[:return_uri]).host))
  rescue
    # If for some reason we can't parse the client_id
    # or the return_uri is not a valid URI, just return false
    false
  end
  private :whitelisted_return_uri?

end

class UsersController < Devise::OmniauthCallbacksController
  include Users::PassiveLogin
  prepend_before_action :redirect_root, only: [:show], if: -> { request.path == '/' && user_signed_in? }
  before_action :require_login, only: [:show]
  before_action :require_no_authentication, except: [:passthru, :show, :client_passive_login]
  before_action :require_valid_omniauth_hash, only: (Devise.omniauth_providers << :omniauth_callback)
  respond_to :html

  def show
    @user = User.find_by(username: params[:id], provider: params[:provider])
    if @user == current_user
      respond_with(@user)
    else
      redirect_to user_url(current_user)
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
    if params[:auth_type] == "nyu" || !params[:auth_type]
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
    @root_url_redirect ||= begin
      if ENV['PDS_URL'] && ENV['BOBCAT_URL'] && bobcat_institutions.include?(current_user.institution_code)
        "#{ENV['PDS_URL']}/pds?func=load-login&institute=#{current_user.institution_code}&calling_system=primo&url=#{CGI::escape(ENV['BOBCAT_URL'])}%2fprimo_library%2flibweb%2faction%2fsearch.do%3fdscnt%3d0%26amp%3bvid%3d#{current_user.institution_code}&func=load-login&amp;institute=#{current_user.institution_code}&amp;calling_system=primo&amp;url=#{ENV['BOBCAT_URL']}:80/primo_library/libweb/action/login.do"
      else
        t('application.root_url_redirect')
      end
    end
  end
  private :root_url_redirect

  def bobcat_institutions
    @bobcat_institutions ||= Login::Aleph::Patron::BOR_STATUS_MAPPINGS.map(&:keys).flatten
  end
  private :bobcat_institutions

end

class UsersController < Devise::OmniauthCallbacksController
  prepend_before_filter :check_passive_login, only: :show
  before_filter :require_login, only: :show
  before_filter :require_no_authentication, except: [:show, :check_passive]
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

  def after_omniauth_failure_path_for(scope)
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

  def require_login
    unless user_signed_in?
      redirect_to login_url
    end
  end
  private :require_login


  def check_passive_login
    if !user_signed_in?
      redirect_to user_omniauth_authorize_path(:nyu_shibboleth, institute: current_institute.code, auth_type: :nyu) and return if shib_session_exists?
      if !cookies[:_check_passive_login]
        cookies[:_check_passive_login] = true
        redirect_to passive_shibboleth_url
      end
    end
  end

  def shib_session_exists?
    !cookies.detect {|k,v| k.include? "_shibsession_" }.nil?
  end

  def doorkeeper_client
    @doorkeeper_client ||= Doorkeeper::Application.all.select{ |app| app.uid == params[:client_id] }.first
  end

  def doorkeeper_client_uri
    @doorkeeper_client_uri ||= URI.parse(doorkeeper_client.redirect_uri)
  end

  def doorkeeper_client_login
    return URI.join(doorkeeper_client_uri, params[:login_path]) if params[:login_path]
    URI.join(doorkeeper_client_uri, "/login")
  end

  def return_uri
    @return_uri ||= URI.parse(params[:return_uri])
  end

  def return_uri_base
    URI.join(return_uri, "/")
  end

  def doorkeeper_client_uri_base
    URI.join(doorkeeper_client_uri, "/")
  end

  def return_uri_validated?
    doorkeeper_client && doorkeeper_client_uri_base.eql?(return_uri_base)
  end

  def check_passive
    redirect_to "#{doorkeeper_client_login}" and return if user_signed_in? && !doorkeeper_client.nil?
    redirect_to "#{return_uri}" and return if return_uri_validated?
    return head(:bad_request)
  end

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

  # Use Devise::Models::Authenticatable::ClassMethods#find_for_authentication
  # to take advantage of the Devise case_insensitive_keys and treat USER and user as the same username
  def find_for_authentication(username, provider)
    User.find_for_authentication(username: username, provider: provider) || User.find_or_initialize_by(username: username, provider: provider)
  end

  def passive_shibboleth_url
    "/Shibboleth.sso/Login?isPassive=true&target=#{request.original_url}"
  end
  private :passive_shibboleth_url

end

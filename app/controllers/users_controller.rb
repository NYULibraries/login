class UsersController < Devise::OmniauthCallbacksController
  before_filter :require_login, only: :show
  before_filter :require_no_authentication, except: [:show]
  before_filter :require_valid_omniauth, only: :omniauth_callback
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
    login_path(current_institution.code.downcase)
  end

  def omniauth_callback
    @user = User.find_or_initialize_by(username: omniauth_username, provider: omniauth_identity_provider)
    # Initialize with an email address if the omniauth hash has it.
    @user.email = omniauth_email if @user.email.blank? && omniauth_email.present?
    # Set the OmniAuth::AuthHash for the user
    @user.omniauth_hash = omniauth_hash
    if @user.save
      @identity = @user.identities.find_or_initialize_by(uid: omniauth_uid, provider: omniauth_identity_provider)
      @identity.properties = omniauth_properties if @identity.expired?
      @identity.save
      sign_in_and_redirect @user, event: :authentication
      kind = omniauth_identity_provider.titleize
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to after_omniauth_failure_path_for(resource_name)
    end
  end

  Devise.omniauth_providers.each do |omniauth_provider|
    alias_method omniauth_provider, :omniauth_callback
  end
end

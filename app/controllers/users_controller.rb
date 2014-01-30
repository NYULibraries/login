class UsersController < Devise::OmniauthCallbacksController
  before_filter :require_login, only: :show
  before_filter :require_no_authentication, except: :show
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

  def after_sign_in_path_for(user)
    user_url(user)
  end

  def after_omniauth_failure_path_for(scope)
    login_path(current_institution.code.downcase)
  end

  def omniauth_callback
    omniauth_hash = self.omniauth_hash
    @user = User.find_or_initialize_by(username: omniauth_username, provider: omniauth_provider) do |user|
      user.omniauth_hash = omniauth_hash
      # Initialize with an email address if the omniauth hash has it.
      user.email = omniauth_email if omniauth_email.present?
    end
    if @user.save 
      @identity = @user.identities.find_or_initialize_by(uid: omniauth_uid, provider: omniauth_provider)
      @identity.properties = omniauth_properties if @identity.expired?
      @identity.save
      sign_in_and_redirect @user, :event => :authentication
      kind = "#{params[:action]}".capitalize
      set_flash_message(:notice, :success, :kind => kind) if is_navigational_format?
    else
      redirect_to login_url
    end
  end
  alias_method :aleph, :omniauth_callback
  alias_method :twitter, :omniauth_callback
  alias_method :facebook, :omniauth_callback
end

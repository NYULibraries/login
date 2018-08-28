class UsersController < Devise::OmniauthCallbacksController
  # prepends so that module methods take precedence, and super refers to this controller
  prepend Users::Passthru

  include Users::ClientPassiveLogin
  include Users::EZBorrowLogin
  include Users::OmniauthProvider

  before_action :redirect_root, if: -> { request.path == '/' && user_signed_in? }
  before_action :require_login!, only: [:show, :ezborrow_login]
  before_action :authenticate_user!, only: [:passthru, :client_passive_login]
  respond_to :html

  def show
    @user = User.find_by(username: params[:id], provider: params[:provider])
    if @user == current_user
      render :show
    else
      redirect_to user_url(current_user)
    end
  end

  private

  def redirect_root
    redirect_to root_url_redirect
  end

  def require_login!
    if !user_signed_in?
      store_user_location! if storable_location?
      redirect_to login_url(
        institution: current_institution.code.to_s.downcase
      )
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || super
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def root_url_redirect
    @root_url_redirect ||= begin
      if ENV['PDS_URL'] && ENV['BOBCAT_URL'] && bobcat_institutions.include?(current_user.institution_code)
        "#{ENV['PDS_URL']}/pds?func=load-login&institute=#{current_user.institution_code}&calling_system=primo&url=#{CGI::escape(ENV['BOBCAT_URL'])}%2fprimo_library%2flibweb%2faction%2fsearch.do%3fdscnt%3d0%26amp%3bvid%3d#{current_user.institution_code}&func=load-login&amp;institute=#{current_user.institution_code}&amp;calling_system=primo&amp;url=#{ENV['BOBCAT_URL']}:80/primo_library/libweb/action/login.do"
      else
        t('application.root_url_redirect')
      end
    end
  end

  def bobcat_institutions
    @bobcat_institutions ||= Login::Aleph::Patron::BOR_STATUS_MAPPINGS.keys
  end
end

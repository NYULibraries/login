class UsersController < Devise::OmniauthCallbacksController
  include Users::ClientPassiveLogin
  include Users::EZBorrowLogin
  include Users::OmniauthCallback

  before_action :redirect_root, if: -> { request.path == '/' && user_signed_in? }
  before_action :require_login!, only: [:show, :ezborrow_login]
  before_action :authenticate_user!, only: [:passthru, :client_passive_login]
  respond_to :html

  ESHELF_COOKIE_NAME = '_nyulibraries_eshelf_passthru'.freeze

  def show
    @user = User.find_by(username: params[:id], provider: params[:provider])
    if @user == current_user
      render :show
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

  def redirect_root
    redirect_to root_url_redirect
  end

  def require_login!
    render("wayf/index", institution: institution) unless user_signed_in?
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

  def create_eshelf_cookie!
    cookie_hash = { value: 1, httponly: true, domain: ENV['LOGIN_COOKIE_DOMAIN'] }
    cookies[ESHELF_COOKIE_NAME] = cookie_hash
  end
end

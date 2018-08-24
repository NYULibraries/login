class UsersController < Devise::OmniauthCallbacksController
  include Users::PassiveLogin
  include Users::EZBorrowLogin
  include Users::Passthru
  include Users::OmniAuthProvider

  before_action :require_login!, only: [:show, :ezborrow_login]
  before_action :authenticate_user!,
                only: [:passthru, :client_passive_login]
  respond_to :html

  LOGGED_IN_COOKIE_NAME = '_nyulibraries_logged_in'

  def show
    if request.path == '/' && user_signed_in?
      redirect_root
      return
    end

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
      institution = current_institution.code.downcase.to_s

      redirect_to login_url(
        institution: institution,
        redirect_to: request.path
      )
    end
  end

  def require_valid_omniauth_hash
    redirect_to after_omniauth_failure_path_for(resource_name) unless omniauth_hash_validator.valid?
  end

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

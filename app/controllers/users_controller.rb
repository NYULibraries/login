class UsersController < Devise::OmniauthCallbacksController
  include Users::ClientPassiveLogin
  include Users::EZBorrowLogin
  include Users::Passthru
  include Users::OmniauthProvider

  before_action :require_login!, only: [:show, :ezborrow_login]
  before_action :authenticate_user!, only: [:passthru, :client_passive_login]
  respond_to :html

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
      redirect_to login_url(
        institution: current_institution.code.to_s.downcase,
        redirect_to: request.fullpath
      )
    end
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

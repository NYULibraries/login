module SessionsHelper
  def require_login
    unless user_signed_in?
      redirect_to login_url
    end
  end
end

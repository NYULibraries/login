module CurrentUserHelper
  def current_user?
    current_user.present? && current_user.is_a?(User)
  end

  def require_current_user
    unless current_user?
      flash[:error] = t('application.require_current_user')
      redirect_to login_url
    end
  end
end

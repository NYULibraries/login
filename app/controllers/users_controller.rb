class UsersController < ApplicationController
  before_action :require_login!
  respond_to :html

  def show
    @user = User.find_by(username: params[:id], provider: params[:provider])
    if @user == current_user
      render :show
    else
      redirect_to user_url(current_user)
    end
  end
end

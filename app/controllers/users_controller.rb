class UsersController < ApplicationController
  before_filter :require_current_user
  respond_to :html

  def show
    @user = User.where(username: params[:id]).first
    if @user == current_user
      respond_with(@user)
    else
      redirect_to login_url
    end
  end
end

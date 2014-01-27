class LoginController < ApplicationController
  helper :institutions
  respond_to :html

  def new
    redirect_to(user_url(current_user)) if current_user
    # Otherwise, let Rails do its thing
    # i.e. render the default view
    # (and let us do nothing, the best code is no code)
  end
end

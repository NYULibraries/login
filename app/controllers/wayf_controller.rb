class WayfController < ApplicationController
  respond_to :html
  # Don't allow users to visit the logged_out page with GET, force a logout if that happens
  before_filter :redirect_to_logout, only: [:logged_out], if: -> { user_signed_in? }

  def passthru
    if user_signed_in?
      cookies.delete(:_eshelf_passthru)
      redirect_to (stored_location_for('user') || signed_in_root_path('user'))
    end
    head :bad_request
  end

 private

  def redirect_to_logout
    redirect_to logout_path
  end

end

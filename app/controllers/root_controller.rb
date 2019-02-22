class RootController < ApplicationController
  before_action :require_login!, except: [:healthcheck]

  def healthcheck
    render json: {success: true}
    return
  end

end

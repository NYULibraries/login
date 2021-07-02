class RootController < ApplicationController
  before_action :require_login!, except: [:healthcheck]

  def healthcheck
    render json: {success: is_cache_up?}
    return
  end

  private
  def is_cache_up?
    ActionController::Base.new.read_fragment("CACHE_TEST_KEY") == "VALID"
  end

end

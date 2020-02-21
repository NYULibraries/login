module Api::V1
  class UsersController < ::ApplicationController
    before_action :doorkeeper_authorize!
    respond_to :json
    layout false

    def show
      if doorkeeper_token
        @user = User.find(doorkeeper_token.resource_owner_id)
        respond_with(@user, include: :identities, methods: :auth_groups)
      end
    end

  end
end

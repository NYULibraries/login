module Api::V1
  class UsersController < ::ApplicationController
    doorkeeper_for :all
    respond_to :json

    def show
      if doorkeeper_token
        @user = User.find(doorkeeper_token.resource_owner_id)
        respond_with(@user, include: :identities)
      end
    end

  end
end

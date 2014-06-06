require 'spec_helper'

describe UsersController do

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET #api' do

    let!(:application) { Doorkeeper::Application.create!(:name => "MyApp", :redirect_uri => "http://app.com") }
    let!(:user) { FactoryGirl.create(:user) }
    let!(:token) { Doorkeeper::AccessToken.create! :application_id => application.id, :resource_owner_id => user.id }

    it 'responds with 200' do
      get :api, :format => :json, :access_token => token.token
      expect(response.status).to be 200
    end

    it 'returns the user as json' do
      get :api, :format => :json, :access_token => token.token
      expect(response.body).to eql user.to_json
    end
  end

end

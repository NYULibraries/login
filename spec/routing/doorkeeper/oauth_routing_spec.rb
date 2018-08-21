require 'rails_helper'

describe "routes for Doorkeeper" do

  describe "GET /oauth/authorize/:code" do
    subject { get('/oauth/authorize/native?code=1234') }
    it { should route_to(controller: 'doorkeeper/custom_authorizations', action: 'show', code: '1234') }
  end

  describe "GET /oauth/authorize" do
    subject { get('/oauth/authorize') }
    it { should route_to(controller: 'doorkeeper/custom_authorizations', action: 'new') }
  end

  describe "POST /oauth/authorize" do
    subject { post('/oauth/authorize') }
    it { should route_to(controller: 'doorkeeper/custom_authorizations', action: 'create') }
  end

  describe "DELETE /oauth/authorize" do
    subject { delete('/oauth/authorize') }
    it { should route_to(controller: 'doorkeeper/custom_authorizations', action: 'destroy') }
  end

  describe "POST /oauth/token" do
    subject { post('/oauth/token') }
    it { should route_to(controller: 'doorkeeper/tokens', action: 'create') }
  end

  describe "GET /oauth/applications" do
    subject { get('/oauth/applications') }
    it { should route_to(controller: 'doorkeeper/applications', action: 'index') }
  end

  describe "POST /oauth/applications" do
    subject { post('/oauth/applications') }
    it { should route_to(controller: 'doorkeeper/applications', action: 'create') }
  end

  describe "GET /oauth/applications/new" do
    subject { get('/oauth/applications/new') }
    it { should route_to(controller: 'doorkeeper/applications', action: 'new') }
  end

  describe "GET /oauth/applications/:id/edit" do
    subject { get('/oauth/applications/1/edit') }
    it { should route_to(controller: 'doorkeeper/applications', action: 'edit', id: '1') }
  end

  describe "GET /oauth/applications/:id" do
    subject { get('/oauth/applications/1') }
    it { should route_to(controller: 'doorkeeper/applications', action: 'show', id: '1') }
  end

  describe "PATCH /oauth/applications/:id" do
    subject { patch('/oauth/applications/1') }
    it { should route_to(controller: 'doorkeeper/applications', action: 'update', id: '1') }
  end

  describe "PUT /oauth/applications/:id" do
    subject { put('/oauth/applications/1') }
    it { should route_to(controller: 'doorkeeper/applications', action: 'update', id: '1') }
  end

  describe "DELETE /oauth/applications/:id" do
    subject { delete('/oauth/applications/1') }
    it { should route_to(controller: 'doorkeeper/applications', action: 'destroy', id: '1') }
  end

  describe "GET /oauth/authorized_applications" do
    subject { get('/oauth/authorized_applications') }
    it { should route_to(controller: 'doorkeeper/authorized_applications', action: 'index') }
  end

  describe "DELETE /oauth/authorized_applications/:id" do
    subject { delete('/oauth/authorized_applications/1') }
    it { should route_to(controller: 'doorkeeper/authorized_applications', action: 'destroy', id: '1') }
  end

  describe "GET /oauth/token/info" do
    subject { get('/oauth/token/info') }
    it { should route_to(controller: 'doorkeeper/token_info', action: 'show') }
  end

end

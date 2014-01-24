require 'spec_helper'

describe UsersController do

  describe "GET 'show'" do
    context "when not rendering views" do
      render_views false
      subject { get :show; response }
      it { should be_success }
      it("should have a 200 status") { expect(subject.status).to be(200) }
    end

    context "when rendering views" do
      render_views
      subject { get :show; response }

      it do
        should render_template("layouts/login")
        should render_template("users/show")
        should render_template("common/_alerts")
      end
    end
  end
end

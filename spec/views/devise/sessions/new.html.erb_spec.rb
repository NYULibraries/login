require 'rails_helper'

describe "devise/sessions/new.html.erb" do
  before { allow(controller).to receive(:params).and_return({ auth_type: "ns" }) }
  subject { render; rendered }
  it do
    should match("Login with")
  end
end

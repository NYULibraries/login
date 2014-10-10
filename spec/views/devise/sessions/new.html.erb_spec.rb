require 'spec_helper'

describe "devise/sessions/new.html.erb" do
  before { controller.stub(:params).and_return({ auth_type: "ns" }) }
  subject { render; rendered }
  it do
    should match("Login with")
  end
end

require 'rails_helper'

describe "devise/sessions/_visitor.html.erb" do
  let(:current_institution) { "nyu" }
  subject { render; rendered }
  it do
    should match('href="/users/auth/facebook')
    should match('href="/users/auth/twitter')
  end
end

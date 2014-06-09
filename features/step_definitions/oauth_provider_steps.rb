Warden.test_mode!
World Warden::Test::Helpers
Before('@client_app') do
  @client = OAuth2::Client.new("123", "secret123", site: site)
  @current_user = FactoryGirl.create(:user)
end

After('@client_app') do
  Warden.test_reset!
end

Given(/^I am on an NYU client application$/) do
  # Do nothing
end

When(/^I login$/) do
  login_as(@current_user, scope: :user)
  auth_url = @client.auth_code.authorize_url(redirect_uri: "http://example.com")
  visit auth_url
end

Then(/^NYU Libraries' Login authenticates me$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be logged in to the NYU client application$/) do
  pending # express the regexp above with the code you wish you had
end

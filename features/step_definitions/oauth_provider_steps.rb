Given(/^I am logged out$/) do
  OmniAuth.config.mock_auth[:nyu_shibboleth] = nil
end

Given(/^I am on an OAuth2 client application$/) do
  expect(client).not_to be_nil
  expect(client).to be_instance_of OAuth2::Client
end

When(/^I click "Login"$/) do
  # Visit the auth url for this client
  visit client_authorize_url
  click_on "Click to Login"
end

When(/^I have previously logged in to Login as an NYU Shibboleth user$/) do
  # Log user in via NYU Shibboleth, by mocking environment
  set_nyu_shibboleth_login_env
end

When(/^I login to Login as an NYU Shibboleth user$/) do
  set_nyu_shibboleth_login_env
  visit client_authorize_url
  click_on "Click to Login"
end

Then(/^I should (not )?see the Login page$/) do |negator|
  expectations_for_page(page, negator, *nyu_login_matchers)
end

# How can you test that you're logged into a non-existance app?
# For now, you can just make sure that an authorization code is returned
Then(/^I should be logged in to the OAuth2 client application$/) do
  expect(page).to have_content authorization_code
end

# I should not be prompted with an authorize screen
# I should just receive the authorization code in the page
# If this was production it would return to the redirect_uri with code=auth_code in the querystring
Then(/^I should be automatically authorized to use Login as my provider$/) do
  expect(page).to have_content authorization_code
end

Then(/^the OAuth2 client should (not )?have access to exposed attributes$/) do |negator|
  begin
    get api_v1_user_path(:access_token => access_token)
    expect(last_response.body).to include current_resource_owner.to_json(include: :identities)
  rescue Exception => e
    expect(negator).to include "not"
    expect(e).to be_instance_of(OAuth2::Error)
    expect(e.message).to include "invalid_grant"
  end
end

Given(/^I am logged out$/) do
  OmniAuth.config.mock_auth[:nyu_shibboleth] = nil
end

Given(/^I am on an NYU client application$/) do
  expect(client).not_to be_nil
  expect(client).to be_instance_of OAuth2::Client
end

Then(/^I click "Login" on the client application$/) do
  # Visit the auth url for this client
  visit client_authorize_url
  click_on "Click to Login"
  expect(auth_code).to have_content if current_resource_owner
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

Then(/^I should see the Login page$/) do
  expectations_for_page(page, "", *nyu_login_matchers)
end

Then(/^I should be logged in to the NYU client application$/) do
  VCR.use_cassette("get access token", match_requests_on: [:path], record: :all) do
    get api_v1_user_path(:access_token => access_token)
    expect(last_response.body).to include "snowj@newschool.edu"
  end
end

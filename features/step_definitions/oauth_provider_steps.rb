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

Then(/^I should be logged in to the OAuth2 client application$/) do
  expect(authorization_code).to have_content
end

Then(/^the OAuth2 client should have access to exposed attributes$/) do
  VCR.use_cassette("get access token", match_requests_on: [:path], record: :all) do
    get api_v1_user_path(:access_token => access_token)
    expect(last_response.body).to include current_resource_owner.to_json(include: :identities)
  end
end

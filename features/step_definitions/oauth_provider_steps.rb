Given(/^I am on an NYU client application$/) do
  set_provider_url
  expect(client).not_to be_nil
  expect(client).to be_instance_of OAuth2::Client
end

When(/^I have (previously )?logged in to Login as an NYU Shibboleth user$/) do |previously|
  login_and_authorize_nyu_shibboleth_user
end

Then(/^I should see the Login page$/) do
  expectations_for_page(page, "", *nyu_login_matchers)
  # pending # express the regexp above with the code you wish you had
end

Then(/^I click Login on the client application$/) do
  # Visit the auth url for this client
  visit client_authorize_url
  expect(auth_code).to have_content if current_resource_owner
end

Then(/^I should be logged in to the NYU client application$/) do
  # Visit the protected API
  visit api_v1_user_path(:access_token => access_token)
  expect(body).to include current_resource_owner.to_json(include: :identities)
end

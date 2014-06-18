Before('@client_app') do
  visit login_path
  url = URI.parse(current_url)
  @site = "#{url.scheme}://#{url.host}:#{url.port}"
end

Given(/^I am on an NYU client application$/) do
  expect(client).not_to be_nil
  expect(client).to be_instance_of OAuth2::Client
end

When(/^I login via NYU Shibboleth$/) do
  # Log user in via NYU Shibboleth
  login_as_nyu_shibboleth
  # Visit the callback to ensure login and user creation
  visit nyu_home_url
  # Make sure this user is authorized for this app
  oauth_app.authorized_tokens.create(resource_owner_id: current_resource_owner.id)
end

Then(/^NYU Libraries' Login authorizes me for the client application$/) do
  # Visit the auth url for this client
  visit auth_url
  expect(auth_code).to have_content
end

Then(/^I should be logged in to the NYU client application$/) do
  # Visit the protected API
  visit api_v1_user_path(:access_token => access_token)
  expect(body).to include current_resource_owner.to_json(include: :identities)
end

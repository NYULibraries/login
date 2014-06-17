Warden.test_mode!
World Warden::Test::Helpers

Before('@client_app') do
  visit login_path
  url = URI.parse(current_url)
  @site = "#{url.scheme}://#{url.host}:#{url.port}"
  @app = FactoryGirl.create(:oauth_app_no_redirect)
end

After('@client_app') do
  Warden.test_reset!
end

Given(/^I am on an NYU client application$/) do
  @client = OAuth2::Client.new(@app.uid, @app.secret, site: @site)
end

When(/^I login via NYU Shibboleth$/) do
  # Log user in via NYU Shibboleth
  login_as_nyu_shibboleth
  # Visit the callback to ensure login and user creation
  visit nyu_home_url
  # Create an instance variable from this logged in user
  @resource_owner = User.where(username: shibboleth_hash[:uid], provider: shibboleth_hash[:provider]).first
  # Make sure this user is authorized for this app
  @auth_token = @app.authorized_tokens.create(resource_owner_id: @resource_owner.id)
end

Then(/^NYU Libraries' Login authorizes me for the client application$/) do
  # Get the auth url for this client
  @auth_url = @client.auth_code.authorize_url(:redirect_uri => @app.redirect_uri)
  # And redirect there
  visit @auth_url
  expect(page.find("#authorization_code").text).to have_content
end

Then(/^I should be logged in to the NYU client application$/) do
  # Get the access token
  token = @app.authorized_tokens.where(resource_owner_id: @resource_owner.id).first
  # Visit the protected API
  visit api_v1_user_path(:access_token => token.token)
  expect(body).to include @resource_owner.to_json(include: :identities)
end

Before('@client_app') do
  visit login_path
  url = URI.parse(current_url)
  @site = "#{url.scheme}://#{url.host}:#{url.port}"
end

Given(/^I am logged in as an New School LDAP user$/) do
  login_as_newschool_ldap
end

When(/^I request my attributes from the protected API$/) do
  visit auth_url
  click_on "New School Libraries"
  click_on "Login"
end

Then(/^I retrieve the attributes as JSON:$/) do |table|
  VCR.use_cassette("get access token", match_requests_on: [:path], record: :all) do
    get api_v1_user_path(:access_token => access_token)
    expect(last_response.body).to include "NOTINHERE"
  end
end

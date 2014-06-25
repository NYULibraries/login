Given(/^I am logged in as a New School LDAP user$/) do
  set_new_school_ldap_login_env
end

When(/^I request my attributes from the protected API$/) do
  visit client_authorize_url
  click_on "New School Libraries"
  click_on "Login"
end

Then(/^I retrieve the attributes as JSON:$/) do |table|
  VCR.use_cassette("get access token", match_requests_on: [:path], record: :all) do
    get api_v1_user_path(:access_token => access_token)
    expect(last_response.body).to include "snowj@1newschool.edu"
  end
end

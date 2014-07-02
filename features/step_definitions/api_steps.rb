Given(/^I am logged in as a New School LDAP user$/) do
  set_new_school_ldap_login_env
end

When(/^I request my attributes from the protected API$/) do
  visit client_authorize_url
  click_on "New School Libraries"
  click_on "Login"
end

Then(/^I retrieve the attributes as JSON:$/) do |table|
  # Get attributes from API with a get call
  get api_v1_user_path(:access_token => access_token)
  # Match retrieved result with expectant attrs
  table.rows_hash.each do |field_title, value|
    expect(last_response.body).to include "\"#{map_title_to_field(field_title)}\":\"#{value}\""
  end
end

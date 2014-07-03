Given(/^I am logged in as a "(.*?)" user$/) do |location|
  set_login_env_for location
  visit client_authorize_url
  follow_login_steps_for location
end

When(/^I request my attributes from the protected API$/) do
  # Get attributes from API with a get call
  get api_v1_user_path(:access_token => access_token)
end

Then(/^I retrieve the attributes as JSON:$/) do |table|
  # Match retrieved result with expectant attrs
  table.rows_hash.each do |field_title, value|
    expect(last_response.body).to include "\"#{map_title_to_field(field_title)}\":\"#{value}\""
  end
end

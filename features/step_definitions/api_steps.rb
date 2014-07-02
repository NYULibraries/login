Given(/^I am logged in as a "(.*?)" user$/) do |location|
  set_login_env_for location
  visit client_authorize_url
  follow_login_steps_for location
end

When(/^I request my attributes from the protected API$/) do
  get api_v1_user_path(:access_token => access_token)
end

Then(/^I retrieve the attributes as JSON:$/) do |table|
  parsed_user = JSON.parse(last_response.body)
  resource_owner = current_resource_owner(parsed_user["provider"])

  expect(last_response.body).to eql resource_owner.to_json(include: :identities)

  table.rows_hash.each do |field, value|
    expect(parsed_user["identities"].first["properties"][map_field_to_title(field)]).to eql value
  end
end

Given(/^I am logged in as a New School LDAP user$/) do
  set_new_school_ldap_login_env
end

When(/^I request my attributes from the protected API$/) do
  visit client_authorize_url
  click_on "New School Libraries"
  click_on "Login"
end

Then(/^I retrieve the attributes as JSON:$/) do |table|
  get api_v1_user_path(:access_token => access_token)

  parsed_user = JSON.parse(last_response.body)
  resource_owner = current_resource_owner(parsed_user["provider"])

  expect(last_response.body).to eql resource_owner.to_json(include: :identities)

  table.rows_hash.each do |field, value|
    expect(parsed_user["identities"].first["properties"][map_field_to_title(field)]).to eql value
  end
end

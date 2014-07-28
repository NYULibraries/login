Given(/^I am logged in as an admin$/) do
  set_admin_login_env
  visit client_authorize_url
  login_as_admin
  visit "/login"
end

Given(/^I am a logged out user$/) do
  ensure_logout
  visit "/login"
end

When(/^I go to the client applications page$/) do
  visit "/oauth/applications"
end

When(/^I go to the new client applications page$/) do
  visit "/oauth/applications/new"
end

When(/^I click on the applications link$/) do
  click_on "applications"
end

When(/^I fill out the form with the following fields:$/) do |table|
  table.rows_hash.each do |field_title, value|
    fill_in field_title, with: value
  end
  click_button "Submit"
end

When(/^I click add new application$/) do
  click_link "New Application"
end

Then(/^I should (not )?have access to the list of applications$/) do |negator|
  expectations_for_page(page, negator, *authorize_applications_matchers)
end

Then(/^I should see that the application is added$/) do
  expect(page).to have_text("Application created.")
end

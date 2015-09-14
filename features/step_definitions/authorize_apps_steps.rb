Given(/^I am logged in as an admin$/) do
  set_admin_login_env
  visit client_authorize_url
  login_as_admin
  visit "/auth/nyu"
end

Given(/^I am a logged out user$/) do
  ensure_logout
  visit "/login"
end

Given(/^I am logged in as a non\-admin user$/) do
  step "I am logged in as a \"New School LDAP\" user"
end

When(/^I go to my user page$/) do
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

Then(/^I should (not )?see the list of applications$/) do |negator|
  expectations_for_page(page, negator, *authorize_applications_matchers)
end

Then(/^I should see that the application is added$/) do
  expect(page).to have_text("Application created.")
end

Then(/^I should not see the form to add a new application$/) do
  expect(page).to_not have_css("#new_application")
end

Then(/^I should not see the link to the list of client applications$/) do
  expect(page).to_not have_link("applications")
end

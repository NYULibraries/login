Given(/^I am logged in as a "(.*?)" admin$/) do |location|
  set_admin_login_env_for_location location
  visit client_authorize_url
  follow_login_steps_for_location location
end

When(/^I go to the client applications page$/) do
  visit "/oauth/applications"
end

Then(/^I should (not )?have access to the list of applications$/) do |negator|
  expectations_for_page(page, negator, *authorize_applications_matchers)
end

When(/^I click add new application$/) do
  click_link "New Application"
end

When(/^I add the application$/) do
  fill_in "application_name", with: "test"
  fill_in "application_redirect_uri", with: "urn:ietf:wg:oauth:2.0:oob"
  click_button "Submit"
end

Then(/^I should see that the application is added$/) do
  expect(page).to have_text("Application created.")
end

Given(/^I am a logged out user$/) do
  OmniAuth.config.mock_auth.clear
  visit "/login"
end

Given(/^I am on my user page$/) do
  visit users_show_path
end

When(/^I want to login$/) do
  # When on travis were already on the correct institution login page at this point
  visit '/login' unless ENV['TRAVIS']
end

Then(/^my primary login option should be (.+)$/) do |location|
  if location == "NYU"
    expect(page).to have_css("#nyu_shibboleth-login.primary-login")
  else
    expect(page).to have_css("##{institution_for_location(location).downcase}-login.primary-login")
  end
end

When(/^I want to login with (.+)$/) do |account|
  visit login_path(institution_for_location(account))
end

Then(/^I should go to the (.+) authentication page$/) do |location|
  expect(current_path).to start_with(auth_path(institution_for_location(location).downcase))
end

Then(/^I should be logged in as an NYU New York user$/) do
  expectations_for_page(page, nil, *shibboleth_logged_in_matchers("NYU New York"))
end

Then(/^I should be logged in as an NYU Shanghai user$/) do
  expectations_for_page(page, nil, *shibboleth_logged_in_matchers("NYU Shanghai"))
end

Then(/^I should be logged in as an NYU Abu Dhabi user$/) do
  expectations_for_page(page, nil, *shibboleth_logged_in_matchers("NYU Abu Dhabi"))
end

Given(/^I am on the (.+) login page$/) do |location|
  visit_login_page_for_location(location)
  expect_login_page_for_location(location)
end

When(/^I visit the (.+) login page$/) do |location|
  visit_login_page_for(location)
  expect_login_page_for(location)
end

Then(/^I should see a(n)? "(.*?)" login page$/) do |ignore, location|
  expectations_for_page(page, nil, *nyu_style_matchers)
end

When(/^NYU Home authenticates me as a(n)? "(.*?)" user$/) do |ignore, location|
  visit nyu_shibboleth_callback_url(location)
end

When(/^NYU Home authenticates me$/) do
  visit nyu_shibboleth_callback_url
end

Then(/^I should be redirected to the (.+?) login page$/) do |location|
  expect_login_page_for(location)
end

When(/^I click on the "(.*?)" button$/) do |button|
  if button == "NYU"
    expect(page).to have_xpath("//a[contains(@href, '#{user_nyu_shibboleth_omniauth_authorize_path}')]")
  else
    click_on button
  end
end

When(/^I enter my Library Patron ID for "(.*?)" and first four letters of my last name$/) do |location|
  within("#aleph") do
    fill_in 'Enter your', with: username_for_location(location)
    fill_in 'First four letters of your last name', with: password_for_location(location)
    click_button 'Login'
  end
end

When(/^I incorrectly enter my Library Patron ID and first four letters of my last name$/) do
  within("#aleph") do
    fill_in 'Enter your', with: 'copper'
    fill_in 'First four letters of your last name', with: 'onion'
    click_button 'Login'
  end
end

Then(/^I should( not)? be logged in as a Cooper Union user$/) do |negate|
  expectations_for_page(page, negate, *aleph_logged_in_matchers("Cooper Union"))
end

Then(/^I should( not)? be logged in as a New York School of Interior Design user$/) do |negate|
  expectations_for_page(page, negate, *aleph_logged_in_matchers("NYSID"))
end

Then(/^I should( not)? be logged in as a Bobst Affiliate user$/) do |negate|
  expectations_for_page(page, negate, *aleph_logged_in_matchers("Bobst Affiliate"))
end

Then(/^I should get an informative message about my incorrect credentials$/) do
  expectations_for_page(page, nil, *mismatched_aleph_credentials_matchers)
end

When(/^I submit the login form$/) do
  click_on("Login")
end

Then(/^I should see the error message "(.*?)"$/) do |message|
  expectations_for_page(page, nil, *error_matchers(message))
end

When(/^I visit the root url$/) do
  visit root_path
end

Then(/^I should be redirected to "(.*?)"$/) do |url|
  expect(current_url).to match(url)
end

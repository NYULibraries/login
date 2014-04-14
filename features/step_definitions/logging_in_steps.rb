Given(/^I am off campus$/) do
  # page.driver.options[:headers] = {'REMOTE_ADDR' => '127.0.0.1'}
end

Given(/^I am at (.+)$/) do |location|
  ip = ip_for_location(location)
  # page.driver.options[:headers] = {'REMOTE_ADDR' => ip}
end

When(/^I want to login$/) do
  visit '/login'
end

When(/^I want to login with (.+)$/) do |account|
  visit login_path(institute_for_location(account))
end

When(/^I want to login to (.+)$/) do |location|
  visit login_path(institute_for_location(location))
end

When(/^I enter my New School NetID and password$/) do
  within("#new_school_ldap") do
    fill_in 'Enter your NetID Username', with: username_for_location('New School')
    fill_in 'Enter your NetID Password', with: password_for_location('New School')
    # click_button 'Login'
  end
end

Then(/^I should (not )?see the NYU torch login button$/) do |negator|
  expectations_for_page(page, negator, *nyu_login_matchers)
end

Then(/^I should (not )?be able to login with a New School account$/) do |negator|
  expectations_for_page(page, negator, *ns_login_matchers)
end

Then(/^I should (not )?be able to login with a Cooper Union account$/) do |negator|
  expectations_for_page(page, negator, *cu_login_matchers)
end

Then(/^I should (not )?be able to login with a NYSID account$/) do |negator|
  expectations_for_page(page, negator, *nysid_login_matchers)
end

Then(/^I should (not )?see an option to login with an NYU account$/) do |negator|
  expectations_for_page(page, negator, *nyu_option_matchers)
end

Then(/^I should (not )?see an option to login with a New School account$/) do |negator|
  expectations_for_page(page, negator, *ns_option_matchers)
end

Then(/^I should (not )?see an option to login with a Cooper Union account$/) do |negator|
  expectations_for_page(page, negator, *cu_option_matchers)
end

Then(/^I should (not )?see an option to login with a NYSID account$/) do |negator|
  expectations_for_page(page, negator, *nysid_option_matchers)
end

Then(/^I should (not )?see an option to login with an NYU Libraries Affiliates' account$/) do |negator|
  expectations_for_page(page, negator, *bobst_option_matchers)
end

Then(/^I should (not )?see an option to login with a Twitter account$/) do |negator|
  expectations_for_page(page, negator, *twitter_option_matchers)
end

Then(/^I should (not )?see an option to login with a Facebook account$/) do |negator|
  expectations_for_page(page, negator, *facebook_option_matchers)
end

When(/^I press the New School login option$/) do
  click_link 'New School Libraries'
end

Then(/^I should go to the (.+) login page$/) do |location|
  expect(current_path).to eq(login_path(institute_for_location(location).downcase))
end

Then(/^I should (not )?be logged in as(\s?a|an)? (.+) user$/) do |negator, ignore, account|
  expectations_for_page(page, negator, *logged_in_matchers(account))
end

Given(/^I am on the Libraries' central login page$/) do
  visit '/login'
end

Given(/^I am on the (.+) login page$/) do |location|
  visit_login_page_for(location)
  expect_login_page_for(location)
end

When(/^I visit the (.+) login page$/) do |location|
  visit_login_page_for(location)
  expect_login_page_for(location)
end

Then(/^I should see a(n)? "(.*?)" login page$/) do |ignore, location|
  expectations_for_page(page, nil, *nyu_style_matchers)
end

When(/^I click on the torch logo$/) do
  click_link 'Click to Login'
end

When(/^I am redirected to the NYU central login page$/) do
  expectations_for_page(page, nil, *shib_login_matchers)
end

When(/^I enter my NYU NetID and password (correctly|incorrectly)$/) do |correct_credentials|
  within("#login") do
    fill_in 'netid', with: username_for_location('NYU New York')
    if correct_credentials == "correctly"
      fill_in 'password', with: password_for_location('NYU New York')
    else
      fill_in 'password', with: "BAD_CREDENTIALS"
    end
    click_button 'Login'
  end
end

Then(/^I should be redirected to the Libraries' central login page$/) do
  # Do nothing
end

Then(/^I should see a(n)? "(.*?)" error on the NYU central login page$/) do |ignore, error_message|
  expect(page).to have_content(error_message)
end

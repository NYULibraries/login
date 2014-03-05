Given(/^I am off campus$/) do
  page.driver.options[:headers] = {'REMOTE_ADDR' => '127.0.0.1'}
end

Given(/^I am at (.+)$/) do |location|
  ip = ip_for_location(location)
  page.driver.options[:headers] = {'REMOTE_ADDR' => ip}
end

When(/^I want to login$/) do
  visit login_path
end

When(/^I want to login with (.+)$/) do |account|
  visit login_path
end

When(/^I want to login to (.+)$/) do |location|
  visit login_path(institute_for_location(location))
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

Then(/^I should go to the New School login page$/) do
  expect(current_path).to eq(login_path('ns'))
end

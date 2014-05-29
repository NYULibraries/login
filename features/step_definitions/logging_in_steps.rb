When(/^I want to login$/) do
  visit '/login'
end

When(/^I want to login with (.+)$/) do |account|
  visit login_path(institute_for_location(account))
end

When(/^I want to login to (.+)$/) do |location|
  visit login_path(institute_for_location(location))
end

Then(/^I should go to the (.+) login page$/) do |location|
  expect(current_path).to eq(login_path(institute_for_location(location).downcase))
end

Then(/^I should be logged in as an NYU user$/) do
  expectations_for_page(page, nil, *shibboleth_logged_in_matchers("NYU New York"))
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

When(/^NYU Home authenticates me$/) do
  visit nyu_home_url
end

Then(/^I should be redirected to the (.+?) login page$/) do |location|
  expect_login_page_for(location)
end

When(/^I click on the "(.*?)" button$/) do |button|
  if button == "NYU login"
    expect(page).to have_xpath("//a[@href='#{user_omniauth_authorize_path(:provider => "nyu_shibboleth", :institute => "NYU")}']")
  elsif button == "NYU AD login"
      expect(page).to have_xpath("//a[@href='#{user_omniauth_authorize_path(:provider => "nyu_shibboleth", :institute => "NYUAD")}']")
  elsif button == "NYU SH login"
      expect(page).to have_xpath("//a[@href='#{user_omniauth_authorize_path(:provider => "nyu_shibboleth", :institute => "NYUSH")}']")
  else
    click_link(button)
  end
end

When(/^I enter my Library Patron ID for "(.*?)" and first four letters of my last name$/) do |location|
  within("#aleph") do
    fill_in 'Enter your ID Number', with: username_for_location(location)
    fill_in 'First four letter of your last name', with: password_for_location(location)
    click_button 'Login'
  end
end

When(/^I incorrectly enter my Library Patron ID and first four letters of my last name$/) do
  within("#aleph") do
    fill_in 'Enter your ID Number', with: 'copper'
    fill_in 'First four letter of your last name', with: 'onion'
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

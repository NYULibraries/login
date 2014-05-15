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

Then(/^I should be logged in as a New School user$/) do
  expectations_for_page(page, nil, *logged_in_matchers("New School"))
end

Then(/^I should be logged in as an NYU user$/) do
  expectations_for_page(page, nil, *shibboleth_logged_in_matchers("NYU New York"))
end

Then(/^I should be logged in with my Twitter handle$/) do
  expectations_for_page(page, nil, *logged_in_matchers("Twitter"))
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

When(/^I enter my New School NetID and password$/) do
  within("#new_school_ldap") do
    fill_in 'Enter your NetID Username', with: username_for_location('New School')
    fill_in 'Enter your NetID Password', with: password_for_location('New School')
    click_button 'Login'
  end
end

When(/^I enter my Library Patron ID and first four letters of my last name$/) do
  within("#aleph") do
    fill_in 'Enter your ID Number', with: username_for_location('Cooper Union')
    fill_in 'First four letter of your last name', with: password_for_location('Cooper Union')
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
  expectations_for_page(page, negate, *logged_in_matchers("Cooper Union"))
end

Then(/^I should( not)? be logged in as a New York School of Interior Design user$/) do |negate|
  expectations_for_page(page, negate, *logged_in_matchers("NYSID"))
end

Then(/^I should get an informative message about my incorrect credentials$/) do
  expectations_for_page(page, nil, *mismatched_aleph_credentials_matchers)
end

When(/^Twitter authenticates me$/) do
  if VCR.current_cassette.recording?
    expectations_for_page(page, nil, *twitter_style_matchers)
    within("#oauth_form") do
      fill_in 'Username or email', with: username_for_location("Twitter")
      fill_in 'Password', with: password_for_location("Twitter")
      click_button 'Sign In'
    end
  else
    visit '/users/auth/twitter/callback?institute=NYU'
  end
end

When(/^I wait up to (\d+) seconds for twitter to redirect me$/) do |timeout|
  wait_for_ajax timeout.to_i
end

When(/^I've authorized Twitter to share my information with NYU Libraries$/) do
 # Do nothing
end

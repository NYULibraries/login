When(/^I press the (.+)? login option$/) do |option|
  click_link option
end

When(/^I submit my New School NetID and password$/) do
  within("#new_school_ldap") do
    expect(page).to have_content 'Enter your NetID'
    expect(page).to have_content 'Enter your password'
    expect(page).to have_css "input[value='Login']"
  end
end

When(/^I submit invalid New School credentials$/) do
  set_invalid_new_school_ldap_login_env
  visit new_school_callback_url
end

When(/^New School LDAP authenticates me$/) do
  set_new_school_ldap_login_env
  visit new_school_callback_url
end

Then(/^I should be logged in as a New School user$/) do
  expectations_for_page(page, nil, *newschool_logged_in_matchers)
end

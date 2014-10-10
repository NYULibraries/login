When(/^I press the New School login option$/) do
  click_link 'New School'
end

When(/^I submit my New School NetID and password$/) do
  within("#new_school_ldap") do
    expect(page).to have_content 'Enter your NetID Username'
    expect(page).to have_content 'Enter your NetID Password'
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

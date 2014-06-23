When(/^I press the New School login option$/) do
  click_link 'New School Libraries'
end

Then(/^I should be logged in as a New School user$/) do
  visit newschool_callback_url
  expectations_for_page(page, nil, *newschool_logged_in_matchers)
end

When(/^I submit my New School NetID and password$/) do
  within("#new_school_ldap") do
    expect(page).to have_content 'Enter your NetID Username'
    expect(page).to have_content 'Enter your NetID Password'
    expect(page).to have_css "input[value='Login']"
  end
end

When(/^New School LDAP authenticates me$/) do
  login_as_newschool_ldap
end

When(/^I submit invalid New School credentials$/) do
  submit_invalid_credentials_to_newschool_ldap
  visit newschool_callback_url
end

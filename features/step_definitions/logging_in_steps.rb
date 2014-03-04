When(/^I am at NYU in New York$/) do
  @institute = 'nyu'
end

When(/^I am at NYU in Abu Dhabi$/) do
  @institute = 'nyuad'
end

When(/^I am at NYU in Shanghai$/) do
  @institute = 'nyush'
end

When(/^I am at the New School$/) do
  @institute = 'ns'
end

When(/^I am at Cooper Union$/) do
  @institute = 'cu'
end

When(/^I am at NYSID$/) do
  @institute = 'nysid'
end

When(/^I want to login$/) do
  visit "login/#{@institute}"
end

Then(/^I should see the NYU torch login button$/) do
  expect(page).to have_content 'Login with an NYU NetID'
  expect(page).to have_css '#shibboleth .btn'
end

Then(/^I should see an option to login with a New School account$/) do
  expect(page).to have_content 'New School Libraries'
  expect(page).to have_css '.ns.alt-login'
end

Then(/^I should see an option to login with a Cooper Union account$/) do
  expect(page).to have_content 'The Cooper Union Library'
  expect(page).to have_css '.cu.alt-login'
end

Then(/^I should see an option to login with a NYSID account$/) do
  expect(page).to have_content 'New York School of Interior Design'
  expect(page).to have_css '.nysid.alt-login'
end

Then(/^I should see an option to login with a Twitter account$/) do
  expect(page).to have_content 'Twitter'
  expect(page).to have_css '.twitter.alt-login'
end

Then(/^I should see an option to login with a Facebook account$/) do
  expect(page).to have_content 'Facebook'
  expect(page).to have_css '.facebook.alt-login'
end

Then(/^I should be able to login with a New School account$/) do
  expect(page).to have_content 'Login with a New School NetID'
  expect(page).to have_content 'Enter your NetID Username'
  expect(page).to have_content 'Enter your NetID Password'
end

Then(/^I should see an option to login with an NYU account$/) do
  expect(page).to have_content 'NYU Libraries'
  expect(page).to have_css '.nyu.alt-login'
end

Then(/^I should not see an option to login with a Twitter account$/) do
  expect(page).not_to have_content 'Twitter'
  expect(page).not_to have_css '.twitter.alt-login'
end

Then(/^I should not see an option to login with a Facebook account$/) do
  expect(page).not_to have_content 'Facebook'
  expect(page).not_to have_css '.facebook.alt-login'
end

Then(/^I should not see the NYU torch login button$/) do
  expect(page).not_to have_content 'Login with an NYU NetID'
  expect(page).not_to have_css '#shibboleth .btn'
end

Then(/^I should not see an option to login with a NYSID account$/) do
  expect(page).not_to have_content 'New York School of Interior Design'
  expect(page).not_to have_css '.nysid.alt-login'
end

Then(/^I should be able to login with a Cooper Union account$/) do
  expect(page).to have_content 'Login with your Cooper Union patron ID'
  expect(page).to have_content 'Enter your ID Number'
  expect(page).to have_content 'First four letter of your last name'
end

Then(/^I should be able to login with a NYSID account$/) do
  expect(page).to have_content 'Login with your NYSID patron ID'
  expect(page).to have_content 'Enter your ID Number'
  expect(page).to have_content 'First four letter of your last name'
end

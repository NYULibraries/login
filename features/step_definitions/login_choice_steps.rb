Then(/^I should (not )?see the NYU login button$/) do |negator|
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

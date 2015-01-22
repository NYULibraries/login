Then(/^I should (not )?be able to login with a New School account$/) do |negator|
  expectations_for_page(page, negator, *ns_login_matchers)
end

Then(/^I should (not )?be able to login with a Cooper Union account$/) do |negator|
  expectations_for_page(page, negator, *cu_login_matchers)
end

Then(/^I should (not )?be able to login with a NYSID account$/) do |negator|
  expectations_for_page(page, negator, *nysid_login_matchers)
end

Then(/^I should (not )?be able to login with an Other Borrower account$/) do |negator|
  expectations_for_page(page, negator, *bobst_login_matchers)
end

Then(/^I should (not )?be able to login with an NYU Shanghai Other Borrower account$/) do |negator|
  expectations_for_page(page, negator, *nyush_other_borrower_matchers)
end

Then(/^I should (not )?be able to login with an NYU Abu Dhabi Other Borrower account$/) do |negator|
  expectations_for_page(page, negator, *nyuad_other_borrower_matchers)
end

Then(/^I should (not )?be able to login with a Facebook account$/) do |negator|
  expectations_for_page(page, negator, *facebook_login_matchers)
end

Then(/^I should (not )?be able to login with a Twitter account$/) do |negator|
  expectations_for_page(page, negator, *twitter_login_matchers)
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

Then(/^I should (not )?see an option to login as an Other Borrower$/) do |negator|
  expectations_for_page(page, negator, *bobst_option_matchers)
end

Then(/^I should (not )?see an option to login as a Visitor$/) do |negator|
  expectations_for_page(page, negator, *visitor_option_matchers)
end

Given(/^I visit the "(.*)?" log-out url$/) do |location|
  visit logout_path(institution: institution_for_location(location))
end

Then(/^I should (not )?be on the New School logged out page$/) do |negator|
  expectations_for_page(page, negator, *ns_logout_matchers)
end

Then(/^I should (not )?be on the NYU New York logged out page$/) do |negator|
  expectations_for_page(page, negator, *nyu_logout_matchers)
end

Then(/^I should (not )?be on the NYU Abu Dhabi logged out page$/) do |negator|
  expectations_for_page(page, negator, *nyu_logout_matchers)
end

Then(/^I should (not )?be on the NYU Shanghai logged out page$/) do |negator|
  expectations_for_page(page, negator, *nyu_logout_matchers)
end

Then(/^I should (not )?be on the NYSID logged out page$/) do |negator|
  expectations_for_page(page, negator, *nysid_logout_matchers)
end

Then(/^I should (not )?be on the Cooper Union logged out page$/) do |negator|
  expectations_for_page(page, negator, *cu_logout_matchers)
end

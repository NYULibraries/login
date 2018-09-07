When(/^I visit the (.+) EZ-Borrow url with query "(.*)"$/) do |location, query|
  visit ezborrow_path(location.downcase, query: query)
end

Given(/^I am on the (.+) login page with a redirect to "(.*)"$/) do |location, destination|
  visit_login_page_for_location(location, redirect_to: destination)
  expect_login_page_for_location(location)
end

Given(/^I am (?:an|a) (un)?authorized EZ-Borrow patron$/) do |negator|
  authorized = !negator
  status = authorized ? '60' : '999'
  set_bor_status_for_ezborrow_tests(status)
end

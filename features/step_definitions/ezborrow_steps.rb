When(/^I visit the (.+) EZ-Borrow url with query "(.*)"$/) do |location, query|
  visit ezborrow_path(location.downcase, query: query)
end

Given(/^I am on the (.+) login page with a redirect to "(.*)"$/) do |location, destination|
  visit_login_page_for_location(location, redirect_to: destination)
  expect_login_page_for_location(location)
end

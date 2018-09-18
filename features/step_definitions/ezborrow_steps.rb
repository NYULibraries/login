When(/^I visit the (.+) EZ-Borrow url with query "(.*)"$/) do |location, query|
  visit ezborrow_path(location.downcase, query: query)
end

Given(/^I am on the (.+) login page with a redirect to "(.*)"$/) do |location, destination|
  visit_login_page_for_location(location, redirect_to: destination)
  expect_login_page_for_location(location)
end

Before('@ezborrow_unauthorized') do
  if ENV['FLAT_FILE_STRATEGY_ENABLED']
    set_flat_file('spec/data/patrons-UTF-8-ezborrow-unauthorized.dat')
  end
end

After('@ezborrow_unauthorized') do
  if ENV['FLAT_FILE_STRATEGY_ENABLED']
    set_flat_file('spec/data/patrons-UTF-8.dat')
  end
end

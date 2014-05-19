Given(/^I am off campus$/) do
  # page.driver.options[:headers] = {'REMOTE_ADDR' => '127.0.0.1'}
end

Given(/^I am at (.+)$/) do |location|
  ip = ip_for_location(location)
  # page.driver.options[:headers] = {'REMOTE_ADDR' => ip}
end

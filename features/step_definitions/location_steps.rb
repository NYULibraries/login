Given(/^I am off campus$/) do
  # When not on travis stub an IP that is always off-campus
  unless ci?
    ActionDispatch::Request.any_instance.stub(:remote_ip).and_return('127.0.0.1')
  else
  # When on travis just visit the login page, always off campus
    visit '/login'
  end
end

Given(/^I am at (.+)$/) do |location|
  ip = ip_for_location(location)
  # If a location IP was found then stub it
  if ip.present?
    ActionDispatch::Request.any_instance.stub(:remote_ip).and_return(ip)
  else
  # If no IP was found, visit the institution login page
    visit login_path(institution_for_location(location))
  end
end

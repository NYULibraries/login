Given(/^I am off campus$/) do
  ActionDispatch::Request.any_instance.stub(:remote_ip).and_return('127.0.0.1')
end

Given(/^I am at (.+)$/) do |location|
  ip = ip_for_location(location)
  if ip.present?
    ActionDispatch::Request.any_instance.stub(:remote_ip).and_return(ip)
  else
    visit login_path(institute_for_location(location))
  end
end

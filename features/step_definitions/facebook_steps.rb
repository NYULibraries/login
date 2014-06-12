When(/^Facebook authenticates me$/) do
  # if VCR.current_cassette.recording?
    fill_in("email", with: username_for_location("Facebook"))
    fill_in("pass", with: password_for_location("Facebook"))
    click_button "Log In"
  #   binding.pry
  # else
  #   binding.pry
  #   # visit '/users/auth/facebook/callback'
  # end
end

When(/^I've authorized Facebook to share my information with NYU Libraries$/) do
 # Do nothing
end

When(/^I wait up to (\d+) seconds for Facebook to redirect me$/) do |timeout|
  # wait_for_ajax timeout.to_i
end

Then(/^I should be logged in with my Facebook handle$/) do
  expectations_for_page(page, nil, *logged_in_matchers("Facebook"))
end
Then(/^I should be logged in with my Twitter handle$/) do
  expectations_for_page(page, nil, *logged_in_matchers("Twitter"))
end

When(/^Twitter authenticates me$/) do
  if VCR.current_cassette.recording?
    expectations_for_page(page, nil, *twitter_style_matchers)
    within("#oauth_form") do
      fill_in 'Username or email', with: username_for_location("Twitter")
      fill_in 'Password', with: password_for_location("Twitter")
      click_button 'Sign In'
    end
  else
    visit '/users/auth/twitter/callback?institute=NYU'
  end
end

When(/^I wait up to (\d+) seconds for twitter to redirect me$/) do |timeout|
  wait_for_ajax timeout.to_i
end

When(/^I've authorized Twitter to share my information with NYU Libraries$/) do
  # Do nothing
end

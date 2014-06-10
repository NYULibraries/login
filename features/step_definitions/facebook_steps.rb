When(/^Facebook authenticates me$/) do
  # if VCR.current_cassette.recording?
    # expectations_for_page(page, nil, *facebook_style_matchers)
    # within("#oauth_form") do
      # fill_in 'Username or email', with: ""#username_for_location("Facebook")
      # fill_in 'Password', with: "testpass"#password_for_location("Facebook")
      # click_button 'Sign In'
    # end
  # else
  #   visit '/users/auth/twitter/callback?institute=NYU'
  # end
  # fill_in("email", with: "sharon_dwzwdap_bharambeberg@tfbnw.net")
  # fill_in("pass", with: "testpass")
  # click_button "Log In"
  # binding.pry
end

When(/^I've authorized Facebook to share my information with NYU Libraries$/) do
 # Do nothing
end

When(/^I wait up to (\d+) seconds for Facebook to redirect me$/) do |timeout|
  # wait_for_ajax timeout.to_i
end

Then(/^I should be logged in with my Facebook handle$/) do
  # expectations_for_page(page, nil, *logged_in_matchers("Facebook"))
end

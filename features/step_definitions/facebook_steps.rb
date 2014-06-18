When(/^Facebook authenticates me$/) do
    fill_in("email", with: username_for_location("Facebook"))
    fill_in("pass", with: password_for_location("Facebook"))
    click_button "Log In"

end

Then(/^I should be logged in with my Facebook handle$/) do
  expectations_for_page(page, nil, *logged_in_matchers("Facebook"))
end

When(/^I wait for facebook login page$/) do
  using_wait_time 60 do
    expectations_for_page(page, nil, *facebook_style_matchers)
  end
end

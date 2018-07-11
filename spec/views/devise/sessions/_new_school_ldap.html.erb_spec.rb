require 'rails_helper'

describe "devise/sessions/_new_school_ldap.html.erb" do
  subject { render; rendered }
  it do
    should match(/<div id="new_school_ldap">/)
    should match(/<form/)
    should match('method="post"')
    should match(/action="\/users\/auth\/new_school_ldap\/callback\?institution=/)
    should match(/<legend class="heading">\s*Login with a New School NetID/)
    should match('<label for="username">Enter your NetID</label>')
    should match('<input type="text" name="username" id="username"')
    should match('<label for="password">Enter your password</label>')
    should match('<input type="password" name="password" id="password" class="form-control"')
  end
end

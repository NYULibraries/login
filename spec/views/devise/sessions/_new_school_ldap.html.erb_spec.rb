require 'rails_helper'

describe "devise/sessions/_new_school_ldap.html.erb" do
  subject { render; rendered }
  it do
    should match(/<div id="new_school_ldap">/)
    should match(/<h1>\s+Login with a New School NetID/)
    should match(/<form/)
    should match('method="post"')
    should match(/action="\/users\/auth\/new_school_ldap\/callback\?institution=/)
    should match('<label for="username">Enter your NetID</label>')
    should match('<input class="form-control" id="username" name="username"')
    should match('<label for="password">Enter your password</label>')
    should match('<input class="form-control" id="password" name="password" type="password"')
  end
end

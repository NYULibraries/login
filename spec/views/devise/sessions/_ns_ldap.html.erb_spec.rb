require 'spec_helper'

describe "devise/sessions/_ns_ldap.html.erb" do
  subject { render; rendered }
  it do
    should match(/<div id="ns_ldap">/)
    should match(/<h2>\s+Login with a New School NetID/)
    should match(/<form/)
    should match('method="post"')
    should match(/action="\/users\/auth\/ldap\/callback\?institute=/)
    should match('<label for="username">Enter your NetID Username</label>')
    should match('<input id="username" name="username"')
    should match('<label for="password">Enter your NetID Password</label>')
    should match('<input id="password" name="password" type="password"')
  end
end

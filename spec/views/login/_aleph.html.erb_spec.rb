require 'spec_helper'

describe "login/_aleph.html.erb" do
  subject { render; rendered }
  it do
    should match(/<div id="aleph">/)
    should match(/<h2>\s+Login with/)
    should match(/<form/)
    should match('method="post"')
    should match(/action="\/users\/auth\/aleph\/callback\?institute=/)
    should match('<label for="username">')
    should match('<input id="username" name="username"')
    should match('<label for="password">')
    should match('<input id="password" name="password" type="password"')
  end
end

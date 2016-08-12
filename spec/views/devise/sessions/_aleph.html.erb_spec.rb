require 'rails_helper'

describe "devise/sessions/_aleph.html.erb" do
  subject { render; rendered }
  it do
    should match(/<div id="aleph">/)
    should match(/<form/)
    should match('method="post"')
    should match(/action="\/users\/auth\/aleph\/callback\?institution=/)
    should match('<label for="username">')
    should match('<input type="text" name="username" id="username"')
    should match('<label for="password">')
    should match('<input type="password" name="password" id="password" class="form-control"')
  end
end

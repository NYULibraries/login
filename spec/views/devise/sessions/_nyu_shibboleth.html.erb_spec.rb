require 'spec_helper'

describe "devise/sessions/_nyu_shibboleth.html.erb" do
  subject { render; rendered }
  it do
    should match(/<div id="nyu_shibboleth-login"/)
    should match(/Select your affiliation/)
    should match(/href="\/users\/auth\/nyu_shibboleth\?institute=NYU"/)
    should match('NYU')
    should_not match("<a class=\"nyulibraries-help nyulibraries-help-icon\" ")
  end
end

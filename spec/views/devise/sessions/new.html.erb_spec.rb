require 'spec_helper'

describe "devise/sessions/new.html.erb" do
  pending "add some examples to (or delete) #{__FILE__}"
  subject { render; rendered }
  it do
    should_not match("<a class=\"nyulibraries-help nyulibraries-help-icon\" ")
  end
end

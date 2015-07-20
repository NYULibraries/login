require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe UsersHelper do
  let(:attributes) { attributes_for(:user) }
  let(:base_url) { "http://test.host/users" }
  subject { user_url *args }
  describe '#user_url' do
    context 'when given a User only' do
      let(:args) { [ build(:user) ] }
      it { should eq("#{base_url}/#{attributes[:provider]}/#{attributes[:username]}") }
    end
    context 'when given a User and an institution as String' do
      let(:args) { [ build(:user), "nyu" ] }
      subject { user_url(build(:user), "nyu") }
      it { should eq("#{base_url}/#{attributes[:provider]}/#{attributes[:username]}/nyu") }
    end
    context 'when given a User and an institution as a Hash' do
      let(:args) { [ build(:user), { institution: "nyu" } ] }
      it { should eq("#{base_url}/#{attributes[:provider]}/#{attributes[:username]}/nyu") }
    end
    context 'when not given a User' do
      let(:args) { [ attributes[:provider], attributes[:username] ] }
      it { should eq("#{base_url}/#{attributes[:provider]}/#{attributes[:username]}") }
    end
  end
end

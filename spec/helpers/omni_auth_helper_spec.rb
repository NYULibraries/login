require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the OmniAuthHelper. For example:
#
# describe OmniAuthHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
# describe OmniAuthHelper do
#   before { allow(self).to receive(:request).and_return(@request) }
#   describe '#omniauth_hash' do
#     subject { omniauth_hash }
#     context 'when the request enviroment doesn\'t have an omniauth hash' do
#       it { should be_blank }
#     end
#     context 'when the request enviroment has a valid omniauth hash' do
#       before { params[:action] = "aleph"; @request.env['omniauth.auth'] = authhash(:aleph) }
#       it { should_not be_blank }
#       it { should be_a(OmniAuth::AuthHash) }
#     end
#   end
#
#   describe '#omniauth_uid' do
#     subject { omniauth_uid }
#     context 'when the request enviroment doesn\'t have an omniauth hash' do
#       it { should be_blank }
#     end
#     context 'when the request enviroment has a valid omniauth hash' do
#       before { params[:action] = "aleph"; @request.env['omniauth.auth'] = authhash(:aleph) }
#       it { should_not be_blank }
#       it { should eq("USERNAME") }
#     end
#   end
#
#   describe '#omniauth_identity_provider' do
#     subject { omniauth_identity_provider }
#     context 'when the request enviroment doesn\'t have an omniauth hash' do
#       it { should be_blank }
#     end
#     context 'when the request enviroment has a valid omniauth hash' do
#       context "and it's from an Aleph login" do
#         before { params[:action] = "aleph"; @request.env['omniauth.auth'] = authhash(:aleph) }
#         it { should_not be_blank }
#         it { should eq("aleph") }
#       end
#     end
#   end
#
#   describe '#omniauth_info' do
#     subject { omniauth_info }
#     context 'when the request enviroment doesn\'t have an omniauth hash' do
#       it { should be_blank }
#     end
#     context 'when the request enviroment has a valid omniauth hash' do
#       before { params[:action] = "aleph"; @request.env['omniauth.auth'] = authhash(:aleph) }
#       it { should_not be_blank }
#       it { should be_a(OmniAuth::AuthHash::InfoHash) }
#     end
#   end
#
#   describe '#omniauth_username' do
#     subject { omniauth_username }
#     context 'when the request enviroment doesn\'t have an omniauth hash' do
#       it { should be_blank }
#     end
#     context 'when the request enviroment has a valid omniauth hash from aleph' do
#       before { params[:action] = "aleph"; @request.env['omniauth.auth'] = authhash(:aleph) }
#       it { should_not be_blank }
#       it { should eq("username")}
#     end
#     context 'when the request enviroment has a valid omniauth hash from twitter' do
#       before { params[:action] = "twitter"; @request.env['omniauth.auth'] = authhash(:twitter) }
#       it { should_not be_blank }
#       it { should eq("libtechnyu")}
#     end
#     context 'when the request enviroment has a valid omniauth hash from facebook' do
#       before { params[:action] = "facebook"; @request.env['omniauth.auth'] = authhash(:facebook) }
#       it { should_not be_blank }
#       it { should eq("developer")}
#     end
#     context 'when the request environment has a valid omniauth hash from New School LDAP' do
#       before { params[:action] = "new_school_ldap"; @request.env['omniauth.auth'] = authhash(:new_school_ldap) }
#       it { should_not be_blank }
#       it { should eq("ns123@newschool.edu")}
#     end
#   end
#
#   describe '#omniauth_hash?' do
#     subject { omniauth_hash? }
#     context 'when the request enviroment doesn\'t have an omniauth hash' do
#       it { should be(false) }
#     end
#     context 'when the request enviroment has an omniauth.auth that is not an OmniAuth::AuthHash' do
#       before { @request.env['omniauth.auth'] = "invalid" }
#       it { should be(false) }
#     end
#     context 'when the request enviroment has a invalid omniauth hash' do
#       before { params[:action] = "invalid"; @request.env['omniauth.auth'] = authhash(:aleph) }
#       it { should be(false) }
#     end
#     context 'when the request enviroment has a valid omniauth hash' do
#       before { params[:action] = "aleph"; @request.env['omniauth.auth'] = authhash(:aleph) }
#       it { should be(true) }
#     end
#   end
#
#   describe '#require_valid_omniauth_hash' do
#     context 'when the request enviroment doesn\'t have an omniauth hash' do
#       before { allow(self).to receive(:redirect_to) { true } }
#       it("should redirect to /login") do
#         require_valid_omniauth_hash
#         expect(self).to have_received(:redirect_to).with(login_url)
#       end
#     end
#     context 'when the request enviroment has an omniauth.auth that is not an OmniAuth::AuthHash' do
#       before { allow(self).to receive(:redirect_to) { true } }
#       before { @request.env['omniauth.auth'] = "invalid" }
#       it("should redirect to /login") do
#         require_valid_omniauth_hash
#         expect(self).to have_received(:redirect_to).with(login_url)
#       end
#     end
#     context 'when the request enviroment has a invalid omniauth hash' do
#       before { allow(self).to receive(:redirect_to) { true } }
#       before { params[:action] = "invalid"; @request.env['omniauth.auth'] = authhash(:aleph) }
#       it("should redirect to /login") do
#         require_valid_omniauth_hash
#         expect(self).to have_received(:redirect_to).with(login_url)
#       end
#     end
#     context 'when the request enviroment has a valid omniauth hash' do
#       before { allow(self).to receive(:redirect_to) { true } }
#       before { params[:action] = "aleph"; @request.env['omniauth.auth'] = authhash(:aleph) }
#       it("should not redirect") do
#         require_valid_omniauth_hash
#         expect(self).not_to have_received(:redirect_to)
#       end
#     end
#   end
# end

require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe SessionsHelper do
  describe '#require_login' do
    context 'when logged in' do
      before { allow(self).to receive(:user_signed_in?) { true } }
      before { allow(self).to receive(:redirect_to) { true } }
      it("should not redirect") do
        require_login
        expect(self).not_to have_received(:redirect_to)
      end
    end
    context 'when not logged in' do
      before { allow(self).to receive(:user_signed_in?) { false } }
      before { allow(self).to receive(:redirect_to) { true } }
      it("should redirect to /login") do
        require_login
        expect(self).to have_received(:redirect_to).with(login_url)
      end
    end
  end
end

require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the CurrentUserHelper. For example:
#
# describe CurrentUserHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe CurrentUserHelper do
  describe '#current_user?' do
    subject { current_user? }
    context 'when logged in' do
      let(:user) { build(:user) }
      before { allow(self).to receive(:current_user).and_return(user) }
      it { should be(true) }
    end
    context 'when not logged in' do
      before { allow(self).to receive(:current_user).and_return(nil) }
      it { should be(false) }
    end
    context 'when current user isn\'t a user' do
      before { allow(self).to receive(:current_user).and_return("string") }
      it { should be(false) }
    end
  end

  describe '#require_current_user' do
    context 'when logged in' do
      before { allow(self).to receive(:current_user?) { true } }
      before { allow(self).to receive(:redirect_to) { true } }
      it("should not redirect") do
        require_current_user
        expect(self).not_to have_received(:redirect_to)
      end
    end
    context 'when not logged in' do
      before { allow(self).to receive(:current_user?) { false } }
      before { allow(self).to receive(:redirect_to) { true } }
      it("should redirect to /login") do
        require_current_user
        expect(self).to have_received(:redirect_to).with(login_url)
      end
    end
  end
end

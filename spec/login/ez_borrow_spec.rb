require 'rails_helper'

module Login
  describe EZBorrow do
    let(:aleph_user_with_identities) { create(:aleph_user) }
    let(:user) { EZBorrow.new(aleph_user_with_identities) }
    # let(:unauthorized_non_user) { EZBorrow.new(non_aleph_user_with_identities) }
    let(:barcode) { '1234567890' }

    describe '::initialize' do
      subject { user }
      it { is_expected.to be_a EZBorrow }
      its(:user) { is_expected.to be_a User }
    end

    describe '#authorized?' do
      subject { user.authorized? }

      context 'aleph user' do
        context 'with a valid patron status' do
          # mock authorized user through mocking patron status
          before { aleph_user_with_identities.stub(:aleph_properties) { { patron_status: '20' } } }

          it { is_expected.to be true }
        end

        context 'with an invalid patron status' do
          it { is_expected.to be false }
        end
      end
    end

    describe '#barcode' do
      subject { user.barcode }

      before { aleph_user_with_identities.stub(:aleph_properties) { { barcode: barcode } } }

      it { is_expected.to eql barcode }
    end
  end
end

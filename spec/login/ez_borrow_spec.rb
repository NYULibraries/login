require 'rails_helper'

module Login
  describe EZBorrow do
    let(:aleph_user_with_identities) { create(:aleph_user) }
    let(:user) { EZBorrow.new(aleph_user_with_identities) }
    let(:barcode) { '1234567890' }

    describe '::initialize' do
      subject { user }

      it { is_expected.to be_a EZBorrow }
      its(:user) { is_expected.to be_a User }
    end

    describe '#authorized?' do
      subject { user.authorized? }

      let(:patron_status) { nil }

      before do
        allow(aleph_user_with_identities).
          to receive(:aleph_properties).
          and_return(patron_status: patron_status)
      end

      context 'aleph user' do
        context 'with a valid patron status' do
          let(:patron_status) { '20' }

          it { is_expected.to be true }
        end

        context 'with an invalid patron status' do
          let(:patron_status) { '999' }

          it { is_expected.to be false }
        end
      end
    end

    describe '#barcode' do
      subject { user.barcode }

      before do
        allow(aleph_user_with_identities).
          to receive(:aleph_properties).
          and_return(barcode: barcode)
      end

      it { is_expected.to eql barcode }
    end
  end
end

require 'rails_helper'

describe Login::EZBorrow do
  subject { Login::EZBorrow.new(aleph_user_with_identities) }

  let(:aleph_user_with_identities) { create(:aleph_user) }

  describe '::initialize' do
    it { is_expected.to be_a Login::EZBorrow }
  end

  describe '#authorized?' do
    let(:patron_status) { nil }

    before do
      allow(aleph_user_with_identities).
        to receive(:aleph_properties).
        and_return(patron_status: patron_status)
    end

    context 'aleph user' do
      context 'with a valid patron status' do
        let(:patron_status) { '20' }

        its(:authorized?) { is_expected.to be true }
      end

      context 'with an invalid patron status' do
        let(:patron_status) { '999' }

        its(:authorized?) { is_expected.to be false }
      end
    end
  end

  describe 'maps aleph_properties' do
    before do
      allow(aleph_user_with_identities).
        to receive(:aleph_properties).
        and_return({
          barcode: '1234567890',
          identifier: '12345678907890',
        })
    end

    its(:aleph_barcode) { is_expected.to eql '1234567890' }
    its(:aleph_identifier) { is_expected.to eql '12345678907890' }
  end

  describe 'maps user properites' do
    its(:username) { is_expected.to eql aleph_user_with_identities.username }
    its(:institution_code) { is_expected.to eql aleph_user_with_identities.institution_code }
  end
end

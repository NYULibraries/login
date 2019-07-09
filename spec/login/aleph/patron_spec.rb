require 'rails_helper'
module Login
  module Aleph
    describe Patron do
      let(:identifier) { ENV["TEST_ALEPH_USER"] || 'BOR_ID' }
      let(:patron_status) { '01' }
      let(:patron_type) { 'TP' }
      let(:ill_permission) { 'Y' }
      let(:ill_library) { 'nil' }
      let(:college) { 'College' }
      let(:department) { 'Department' }
      let(:major) { 'Major' }
      let(:plif_status) { 'PLIF_LOADED' }
      let(:bor_name) { "ELOPER, DEV"}
      let(:address) {
        {
          street_address: "70 WASHINGTON SQUARE SOUTH",
          city: "NEW YORK",
          state: "NY",
          postal_code: "10012"
        }
      }
      let(:patron_hash) {
        {
          identifier: identifier,
          patron_status: patron_status,
          patron_type: patron_type,
          ill_permission: ill_permission,
          ill_library: ill_library,
          college: college,
          department: department,
          major: major,
          plif_status: plif_status,
          bor_name: bor_name,
          address: address,
        }
      }
      subject (:patron) do
        Patron.new do |patron|
          patron.identifier = identifier
          patron.patron_status = patron_status
          patron.patron_type = patron_type
          patron.ill_permission = ill_permission
          patron.ill_library = ill_library
          patron.college = college
          patron.department = department
          patron.major = major
          patron.plif_status = plif_status
          patron.bor_name = bor_name
          patron.address = address
        end
      end
      it { should be_a Patron }
      describe '#identifier' do
        subject { patron.identifier }
        it { should eq identifier }
      end
      describe '#patron_status' do
        subject { patron.patron_status }
        it { should eq patron_status }
      end
      describe '#patron_type' do
        subject { patron.patron_type }
        it { should eq patron_type }
      end
      describe '#ill_permission' do
        subject { patron.ill_permission }
        it { should eq ill_permission }
      end
      describe '#ill_permission' do
        subject { patron.ill_library }
        it { should eq ill_library }
      end
      describe '#college' do
        subject { patron.college }
        it { should eq college }
      end
      describe '#department' do
        subject { patron.department }
        it { should eq department }
      end
      describe '#major' do
        subject { patron.major }
        it { should eq major }
      end
      describe '#plif_status' do
        subject { patron.plif_status }
        it { should eq plif_status }
      end
      describe '#first_name' do
        subject { patron.first_name }
        it { should eq "DEV" }
      end
      describe '#last_name' do
        subject { patron.last_name }
        it { should eq "ELOPER" }
      end
      describe '#address' do
        subject { patron.address }
        it { should eq address }
      end
      describe '#to_h' do
        subject { patron.to_h }
        it { should include patron_hash }
      end
      describe '#institution_code' do
        subject { patron.institution_code }
        context 'when patron status is part of the NYU institution' do
          it { should eq "NYU" }
        end
        context 'when patron status is part of the NYUAD institution' do
          let(:patron_status) { "80" }
          it { should eq "NYUAD" }
        end
        context 'when patron status is part of the NYUSH institution' do
          let(:patron_status) { "20" }
          it { should eq "NYUSH" }
        end
        context 'when patron status is part of the CU institution' do
          let(:patron_status) { "10" }
          it { should eq "CU" }
        end
        context 'when patron status is part of the NS institution' do
          let(:patron_status) { "30" }
          it { should eq "NS" }
        end
        context 'when patron status is part of the NYSID institution' do
          let(:patron_status) { "90" }
          it { should eq "NYSID" }
        end
        context 'when patron status is not included in known list of institutions' do
          let(:patron_status) { "xx" }
          it { should eq "NYU" }
        end
        context 'when ill library is ILL_MED' do
          let(:ill_library) { "ILL_MED" }
          it { should eq "HSL" }
        end
      end

      context 'when initialized without a block' do
        subject { Patron.new }
        it 'should raise an ArgumentError' do
          expect{ subject }.to raise_error ArgumentError
        end
      end
    end
  end
end

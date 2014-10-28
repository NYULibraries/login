require 'spec_helper'
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
          plif_status: plif_status
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
      describe '#to_h' do
        subject { patron.to_h }
        it { should include patron_hash }
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

require 'spec_helper'
module Login
  module Aleph
    describe PatronLoader::BorInfoStrategy do
      let(:identifier) { ENV["TEST_ALEPH_USER"] || 'BOR_ID' }
      subject(:bor_info_strategy) { PatronLoader::BorInfoStrategy.new(identifier) }
      it { should be_a PatronLoader::Strategy }
      it { should be_a PatronLoader::BorInfoStrategy }
      describe '#identifier' do
        subject { bor_info_strategy.identifier }
        it { should eq identifier }
      end
      describe '#patron' do
        subject { bor_info_strategy.patron }
        context "when identifier is valid and returns a BorInfo object" do
          its(:identifier) { should eql identifier }
          its(:plif_status) { should be_nil }
          its(:status) { should eql "03" }
          its(:type) { should be_nil }
          its(:ill_permission) { should eql "Y" }
          its(:ill_library) { should be_nil }
        end
        context "when identifier is invalid" do
          let(:identifier) { 'INVALID_ID' }
          it { should be_nil }
        end
      end
    end
  end
end

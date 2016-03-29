require 'rails_helper'
module Login
  module Aleph
    describe PatronLoader::FlatFileStrategy do
      let(:identifier) { 'identifier' }
      subject(:flat_file_strategy) { PatronLoader::FlatFileStrategy.new(identifier) }
      it { should be_a PatronLoader::Strategy }
      it { should be_a PatronLoader::FlatFileStrategy }
      describe '#identifier' do
        subject { flat_file_strategy.identifier }
        it { should eq identifier }
      end
      describe '#patron' do
        subject { flat_file_strategy.patron }
        context "when identifier is valid and returns a BorInfo object" do
          its(:identifier) { should eql identifier }
          its(:plif_status) { should eql "plif_status" }
          its(:patron_status) { should eql "patron_status" }
          its(:patron_type) { should eql "patron_type" }
          its(:ill_permission) { should eql "ill_permission" }
          its(:ill_library) { should eql "ill_library" }
        end
        context "when identifier is invalid" do
          let(:identifier) { 'INVALID_ID' }
          it { should be_nil }
        end
      end
    end
  end
end

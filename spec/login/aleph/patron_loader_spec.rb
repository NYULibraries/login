require 'rails_helper'
module Login
  module Aleph
    describe PatronLoader do
      let(:identifier) { ENV["TEST_ALEPH_USER"] || 'BOR_ID' }
      subject(:patron_loader) { PatronLoader.new(identifier) }
      it { should be_a PatronLoader }
      describe '#identifier' do
        subject { patron_loader.identifier }
        it { should eq identifier }
      end
      describe '#patron' do
        subject { patron_loader.patron }
        it { should be_a Patron }
        context 'when the patron is in the flat file' do
          let(:identifier) { ENV["TEST_FLATFILE_USER"] || 'FLATFILE_ID' }
        end
        context 'when the patron is not in the flat file' do
          context 'but the patron is in Aleph' do
            let(:identifier) { ENV["TEST_ALEPH_USER"] || 'BOR_ID' }
            it { should be_a Patron }
          end
          context 'and the patron is not in Aleph' do
            let(:identifier) { 'INVALID_ID' }
            it { should be_nil }
          end
        end
      end
    end
  end
end

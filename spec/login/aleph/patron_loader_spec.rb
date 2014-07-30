require 'spec_helper'
module Login
  module Aleph
    describe PatronLoader do
      let(:identifier) { 'BOR_ID' }
      subject(:patron_loader) { PatronLoader.new(identifier) }
      it { should be_a PatronLoader }
      describe '#identifier' do
        subject { patron_loader.identifier }
        it { should eq identifier }
      end
      describe '#patron', pending_implementation: true do
        subject { patron_loader.patron }
        it { should be_a Patron }
        context 'when the patron is in the flat file' do
        end
        context 'when the patron is not in the flat file' do
          context 'but the patron is in Aleph' do
          end
          context 'and the patron is not in Aleph' do
            it { should be_nil }
          end
        end
      end
    end
  end
end

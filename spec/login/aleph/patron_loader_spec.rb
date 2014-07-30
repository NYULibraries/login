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
      describe '#patron' do
        subject { patron_loader.patron }
        it { pending;should be_a Patron }
      end
    end
  end
end

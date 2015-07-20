require 'spec_helper'
module Login
  module Aleph
    describe PatronLoader::Strategy do
      let(:identifier) { 'BOR_ID' }
      subject(:strategy) { PatronLoader::Strategy.new(identifier) }
      it { should be_a PatronLoader::Strategy }
      describe '#identifier' do
        subject { strategy.identifier }
        it { should eq identifier }
      end
    end
  end
end

require 'spec_helper'
module Login
  module Aleph
    describe PatronLoader::BorInfoStrategy do
      let(:identifier) { 'BOR_ID' }
      subject(:bor_info_strategy) { PatronLoader::BorInfoStrategy.new(identifier) }
      it { should be_a PatronLoader::Strategy }
      it { should be_a PatronLoader::BorInfoStrategy }
      describe '#identifier' do
        subject { bor_info_strategy.identifier }
        it { should eq identifier }
      end
    end
  end
end

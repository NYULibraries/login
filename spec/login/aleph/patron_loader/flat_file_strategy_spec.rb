require 'spec_helper'
module Login
  module Aleph
    describe PatronLoader::FlatFileStrategy do
      let(:identifier) { 'BOR_ID' }
      subject(:flat_file_strategy) { PatronLoader::FlatFileStrategy.new(identifier) }
      it { should be_a PatronLoader::Strategy }
      it { should be_a PatronLoader::FlatFileStrategy }
      describe '#identifier' do
        subject { flat_file_strategy.identifier }
        it { should eq identifier }
      end
    end
  end
end

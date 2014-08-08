require 'spec_helper'
module Login
  module Aleph
    module XService
      describe BorInfo do
        let(:identifier) { 'BOR_ID' }
        subject(:bor_info) { Aleph::XService::BorInfo.new(identifier) }
        it { should be_a Aleph::XService::BorInfo }
        describe '#identifier' do
          subject { bor_info.identifier }
          it { should eq identifier }
        end
      end
    end
  end
end

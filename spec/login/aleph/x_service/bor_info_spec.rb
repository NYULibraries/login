require 'spec_helper'
module Login
  module Aleph
    module XService
      describe BorInfo do
        let(:identifier) { 'N19064851' }
        let(:bor_info) { Aleph::XService::BorInfo.new(identifier) }
        subject { bor_info }
        it { should be_a Aleph::XService::BorInfo }
        describe '#identifier' do
          subject { bor_info.identifier }
          it { should eq identifier }
        end
        describe '#error' do
          subject { bor_info.error }
          context "when the identifier is valid" do
            it { should be_nil }
          end
          context "when the identifier is invalid" do
            let(:identifier) { "INVALID_ID" }
            it { should eql "Error retrieving Patron System Key" }
          end
        end
        describe '#error?' do
          subject { bor_info.error? }
          context "when the identifier is valid" do
            it { should be_false }
          end
          context "when the identifier is invalid" do
            let(:identifier) { "INVALID_ID" }
            it { should be_true }
          end
        end
      end
    end
  end
end

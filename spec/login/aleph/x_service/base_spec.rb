require 'spec_helper'
module Login
  module Aleph
    module XService
      describe Base do
        let(:host) { 'aleph.library.edu' }
        let(:port) { '80' }
        let(:path) { '/X' }
        let(:library) { 'LIB' }
        let(:base) { Aleph::XService::Base.new(host, port, path, library) }
        describe "#port" do
          subject { base.port }
          it { should eql "80" }
        end
        describe "#path" do
          subject { base.path }
          it { should eql "/X" }
        end
        describe "#library" do
          subject { base.library }
          it { should eql "LIB" }
        end
        describe "#host" do
          subject { base.host }
          context "when port is 80" do
            it { should eql 'http://aleph.library.edu' }
          end
          context "when port is 443" do
            let(:port) { '443' }
            it { should eql 'https://aleph.library.edu' }
          end
          context "when port is anything else" do
            let(:port) { '8981' }
            it { should eql 'http://aleph.library.edu' }
          end
        end
        describe '#response' do
          subject { base.response }
          it "should fail when called by interface class" do
            expect { subject }.to raise_error(RuntimeError)
          end
        end
        describe '#error' do
          subject { base.error }
          it "should fail when called by interface class" do
            expect { subject }.to raise_error(RuntimeError)
          end
        end
        describe '#error?' do
          subject { base.error? }
          it "should fail when called by interface class" do
            expect { subject }.to raise_error(RuntimeError)
          end
        end
      end
    end
  end
end

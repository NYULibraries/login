require 'spec_helper'
module Login
  module Aleph
    module XService
      describe Base do
        let(:host) { 'aleph.library.edu' }
        let(:port) { '80' }
        let(:path) { '/X' }
        let(:library) { '<LIB>' }
        let(:sub_library) { '<SUBLIB>' }
        let(:base) { Aleph::XService::Base.new(host, port, path, library, sub_library) }
        describe "#port" do
          subject { base.port }
          context "when port param is passed in as 80" do
            it { should eql "80" }
          end
          context "when port param is nil" do
            it { should eql "80" }
          end
        end
        describe "#path" do
          subject { base.path }
          context "when path param is passed in as /X" do
            it { should eql "/X" }
          end
          context "when path param is nil" do
            it { should eql "/X" }
          end
        end
        describe "#library" do
          subject { base.library }
          it { should eql "<LIB>" }
        end
        describe "#sub_library" do
          subject { base.sub_library }
          context "when sub library param is passed in" do
            it { should eql "<SUBLIB>" }
          end
          context "when sub library param is nil" do
            let(:sub_library) { nil }
            it { should eql "<LIB>" }
          end
        end
        describe "#host" do
          subject { base.host }
          context "when port is 80" do
            it { should eql 'http://aleph.library.edu' }
          end
          context "when port is 443" do
            let(:port) { "443" }
            it { should eql 'https://aleph.library.edu' }
          end
          context "when port is anything else" do
            let(:port) { "8981" }
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

require 'spec_helper'

describe Login::Primo::Logout do

  let(:bobcat_url) { 'http://bobcatdev.library.nyu.edu' }
  let(:pds_handle) { 'TEST123' }
  let(:logout) { Login::Primo::Logout.new(bobcat_url, pds_handle) }

  describe '.new' do
    subject { logout }
    context 'when bobcat_url is nil' do
      let(:bobcat_url) { nil }
      it 'should raise an argument error' do
        expect { subject }.to raise_error(ArgumentError, "bobcat_url cannot be nil")
      end
    end
    context 'when bobcat_url is not nil' do
      context 'and pds_handle is not nil' do
        context 'but bobcat_url does not match a server mapping' do
          let(:bobcat_url) { 'http://notcat.library.nyu.edu' }
          it 'should raise an argument error' do
            expect { subject }.to raise_error(ArgumentError, "Missing host definition")
          end
        end
      end
    end
  end

  describe '#logout!' do
    subject { logout.logout! }
    it { should be_true }
  end

end

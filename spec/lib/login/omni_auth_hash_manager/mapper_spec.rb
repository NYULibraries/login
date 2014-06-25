require 'spec_helper'

describe Login::OmniAuthHashManager::Mapper do

  let(:provider) { "twitter" }
  let(:omniauth_hash) { authhash(provider) }
  let(:mapper) { Login::OmniAuthHashManager::Mapper.new(omniauth_hash) }

  subject { mapper }

  describe ".new" do
    context "when the OmniAuth::AuthHash is valid" do
      it "should not raise an ArgumentError" do
        expect { subject }.not_to raise_error
      end
      it { should be_a Login::OmniAuthHashManager::Mapper }
    end

    context "when the OmniAuth::AuthHash is invalid" do
      context "when omniauth hash is invalid" do
        let(:omniauth_hash) { {} }
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error Login::OmniAuthHashManager::Validator::ArgumentError
        end
      end
    end
  end

  describe "#to_hash" do
    subject { mapper.to_hash }
    it { should be_a OmniAuth::AuthHash }
  end

end

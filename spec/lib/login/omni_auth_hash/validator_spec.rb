require 'spec_helper'

describe Login::OmniAuthHash::Validator do

  let(:omniauth_hash_provider) { "twitter" }
  let(:provider) { omniauth_hash_provider }
  let(:omniauth_hash) { authhash(omniauth_hash_provider) }
  let(:validator) { Login::OmniAuthHash::Validator.new(omniauth_hash, provider) }

  subject { validator }

  describe ".new" do
    context "when the OmniAuth::AuthHash is valid" do
      context "when provider is passed in" do
        it "should not raise an ArgumentError" do
          expect { subject }.not_to raise_error
        end
      end
    end

    context "when the OmniAuth::AuthHash is invalid" do
      context "when omniauth hash is invalid" do
        let(:omniauth_hash) { {} }
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error Login::OmniAuthHash::Validator::ArgumentError
        end
      end
      context "when provider is invalid" do
        let(:provider) { "invalid" }
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error Login::OmniAuthHash::Validator::ArgumentError
        end
      end
    end
  end

  describe ArgumentError do
    let(:exception_message) { "Invalid hash" }
    let(:argument_error) { Login::OmniAuthHash::Validator::ArgumentError.new(exception_message) }

    it "should generate an ArgumentError" do
      expect(argument_error).to be_a Login::OmniAuthHash::Validator::ArgumentError
      expect(argument_error.message.html_safe).to eql "Invalid hash is not a valid OmniAuth::AuthHash"
    end
  end

end

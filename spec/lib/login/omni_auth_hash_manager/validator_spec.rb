require 'spec_helper'

describe Login::OmniAuthHashManager::Validator do

  let(:omniauth_hash_provider) { "twitter" }
  let(:provider) { omniauth_hash_provider }
  let(:omniauth_hash) { authhash(omniauth_hash_provider) }
  let(:validator) { Login::OmniAuthHashManager::Validator.new(omniauth_hash, provider) }

  subject { validator }

  describe ".new" do
    context "when the OmniAuth::AuthHash is valid" do
      context "when provider is passed in" do
        it "should not raise an ArgumentError" do
          expect { subject }.not_to raise_error
        end
      end
      context "when provider is omitted" do
        let(:provider) { nil }
        it "should not raise an ArgumentError" do
          expect { subject }.not_to raise_error
        end
      end
    end

    context "when the OmniAuth::AuthHash is invalid" do
      context "when omniauth hash is invalid" do
        let(:omniauth_hash) { {} }
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error Login::OmniAuthHashManager::Validator::ArgumentError
        end
      end
      context "when provider is invalid" do
        let(:provider) { "invalid" }
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error Login::OmniAuthHashManager::Validator::ArgumentError
        end
      end
    end
  end

  describe "#valid?" do
    subject { validator.valid? }

    context "when provider is passed in" do
      it { should be_true }
    end
    context "when provider is omitted" do
      let(:provider) { nil }
      it { should be_true }
    end
  end

  describe "#valid_for_action?" do
    before { validator.instance_variable_set(:@omniauth_hash, omniauth_hash) }
    subject { validator.valid_for_action? }
    context "when omniauth hash is valid" do
      context "when provider matches action" do
        it { should be_true }
      end
      context "when provider matches action" do
        before { validator.instance_variable_set(:@provider, "different_than") }
        it { should be_false }
      end
    end
  end

  describe "#valid_hash?" do
    before { validator.instance_variable_set(:@omniauth_hash, omniauth_hash) }
    subject { validator.valid_hash? }
    context "when omniauth hash is valid" do
      it { should be_true }
    end
    context "when omniauth hash is invalid" do
      context "because the hash is nil" do
        before { validator.instance_variable_set(:@omniauth_hash, nil) }
        it { should be_false }
      end
      context "because the hash is empty" do
        before { validator.instance_variable_set(:@omniauth_hash, OmniAuth::AuthHash.new({})) }
        it { should be_false }
      end
      context "because the hash is not OmniAuth::AuthHash" do
        before { validator.instance_variable_set(:@omniauth_hash, Hash.new) }
        it { should be_false }
      end
    end
  end

  describe ArgumentError do
    let(:exception_message) { "Invalid hash" }
    let(:argument_error) { Login::OmniAuthHashManager::Validator::ArgumentError.new(exception_message) }

    it "should generate an ArgumentError" do
      expect(argument_error).to be_a Login::OmniAuthHashManager::Validator::ArgumentError
      expect(argument_error.message.html_safe).to eql "Invalid hash is not a valid OmniAuth::AuthHash"
    end
  end

end

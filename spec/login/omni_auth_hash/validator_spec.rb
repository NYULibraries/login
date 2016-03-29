require 'rails_helper'

describe Login::OmniAuthHash::Validator do

  let(:omniauth_hash_provider) { "twitter" }
  let(:provider) { omniauth_hash_provider }
  let(:omniauth_hash) { authhash(omniauth_hash_provider) }
  let(:validator) { Login::OmniAuthHash::Validator.new(omniauth_hash, provider) }

  subject { validator }

  describe "#valid?" do
    context "when the OmniAuth::AuthHash is invalid" do
      subject { validator.valid? }
      context "when omniauth_hash is empty" do
        let(:omniauth_hash) { {} }
        it { is_expected.to be false }
      end
      context "when provider is invalid" do
        let(:provider) { "invalid" }
        it { is_expected.to be false }
      end
    end
  end


end

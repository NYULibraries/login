require 'spec_helper'

describe Login::OmniAuthHash::Mapper do

  let(:provider) { "twitter" }
  let(:omniauth_hash) { authhash(provider) }
  let(:mapper) { Login::OmniAuthHash::Mapper.new(omniauth_hash) }

  subject { mapper }

  describe ".new" do
    context "when the OmniAuth::AuthHash is valid" do
      it "should not raise an ArgumentError" do
        expect { subject }.not_to raise_error
      end
      it { should be_a Login::OmniAuthHash::Mapper }
    end

    context "when the OmniAuth::AuthHash is invalid" do
      context "when omniauth hash is invalid" do
        let(:omniauth_hash) { {} }
        it "should raise an ArgumentError" do
          expect { subject }.to raise_error Login::OmniAuthHash::Mapper::ArgumentError
        end
      end
    end
  end

  describe "#to_hash" do
    subject { mapper.to_hash }
    it { should be_a OmniAuth::AuthHash }
  end

  describe "#uid" do
    subject { mapper.uid }
    it { should eql omniauth_hash.uid }
  end

  describe "#provider" do
    subject { mapper.provider }
    it { should eql omniauth_hash.provider }
    it { should eql provider }
  end

  describe "#info" do
    subject { mapper.info }
    it { should eql omniauth_hash.info }
  end

  describe "#email" do
    subject { mapper.email }
    it { should eql omniauth_hash.info.email }
  end

  describe "#properties" do
    subject { mapper.properties }
    it { should eql omniauth_hash.info.merge(extra: omniauth_hash.extra) }
  end

  describe "#username" do
    subject { mapper.username }
    context "when provider is twitter" do
      let(:provider) { "twitter" }
      it { should eql omniauth_hash.info.nickname }
    end
    context "when provider is facebook" do
      let(:provider) { "facebook" }
      context "and nickname is present" do
        it { should eql omniauth_hash.info.nickname }
      end
      context "and nickname is missing" do
        before(:each) { omniauth_hash.info.nickname = nil }
        it { should eql omniauth_hash.info.email }
      end
    end
    context "when provider is new_school_ldap" do
      let(:provider) { "new_school_ldap" }
      it { should eql omniauth_hash.info.email }
    end
    context "when provider is nyu_shibboleth" do
      let(:provider) { "nyu_shibboleth" }
      it { should eql omniauth_hash.uid }
    end
  end

end

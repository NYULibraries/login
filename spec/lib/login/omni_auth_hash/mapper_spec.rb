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

  context "when provider is New School Ldap" do
    let(:provider) { "new_school_ldap" }

    describe "#to_hash" do
      subject { mapper.to_hash }
      it { should be_a OmniAuth::AuthHash }
    end

    describe "#uid" do
      subject { mapper.uid }
      it { should eql mapper.to_hash.extra.raw_info[:pdsloginid].first }
    end

    describe "#nyuidn" do
      subject { mapper.nyuidn }
      it { should eql "N00000000" }
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

    describe "#username" do
      subject { mapper.username }
      it { should eql omniauth_hash.info.email }
    end

  end

  context "when provider is not whitelisted" do
    let(:provider) { "malevolent" }

    it "should not be able to create an object from a non-whitelisted provider" do
      expect { mapper.to_hash }.to raise_error NoMethodError
    end
  end

end

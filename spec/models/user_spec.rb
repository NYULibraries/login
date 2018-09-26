require 'rails_helper'

describe User do
  describe 'scopes' do
    before { user; admin }
    let(:user) { create(:user) }
    let(:admin) { create(:admin) }

    describe 'non_admin' do
      subject { User.non_admin.count }
      it { is_expected.to eql 1 }
    end
    describe 'admin' do
      subject { User.admin.count }
      it { is_expected.to eql 1 }
    end
    describe 'inactive' do
      subject { User.inactive.count }
      it { is_expected.to eql 0 }
    end

    describe '::find_for_authentication_or_initialize_by' do
      context 'when user exists' do
        subject do
          User.find_for_authentication_or_initialize_by(
            username: user.username,
            provider: user.provider
          )
        end

        it { is_expected.to be_a User }
        its(:username) { is_expected.to eql user.username }
        its(:provider) { is_expected.to eql user.provider }
      end

      context 'when user does not exist' do
        subject do
          User.find_for_authentication_or_initialize_by(
            username: username,
            provider: provider
          )
        end

        let(:username) { 'new_user_1' }
        let(:provider) { 'oauth_provider_1' }

        it { is_expected.to be_a User }
        its(:username) { is_expected.to eql username }
        its(:provider) { is_expected.to eql provider }
      end
    end
  end

  context "when created with factory defaults" do
    subject { create(:user) }
    it { should be_a(User) }
    it { should_not be_a_new(User) }
    it { should be_valid }
  end

  context "when username is not unique for the same provider" do
    before { create(:user, provider: 'twitter') }
    subject { build(:user, provider: 'twitter') }
    it { should_not be_valid }
  end

  context "when username is not unique for different providers" do
    before { create(:user, provider: 'twitter', email: "") }
    subject { create(:user, provider: 'aleph') }
    it { should be_valid }
  end

  context "when provider is nyu_shibboleth" do
    subject { build(:user, provider: "nyu_shibboleth") }
    it { should be_valid }
  end

  context "when provider is nil" do
    subject { build(:user, provider: nil) }
    it "should raise an error" do
      expect { subject }.to raise_error ArgumentError
    end
  end

  context "when provider is not valid" do
    subject { build(:user, provider: "invalid") }
    it "should raise an error" do
      expect { subject }.to raise_error ArgumentError
    end
  end

  context "when provider is shibboleth" do
    subject { build(:user, provider: "shibboleth") }
    it "should raise an error" do
      expect { subject }.to raise_error ArgumentError
    end
  end

  context "when valid" do
    subject(:user) { build(:user, username: 'dev123', email: 'dev123@example.com', institution_code: 'NYUAD', provider: 'nyu_shibboleth') }
    it { is_expected.to be_instance_of User }
    it { should be_valid }

    describe '#username' do
      subject { user.username }
      it { should_not be_nil }
      it { should eql("dev123") }
    end

    describe '#to_param' do
      subject { user.to_param }
      it { should_not be_nil }
      it { should eql("dev123") }
    end

    describe '#email' do
      subject { user.email }
      it { should_not be_nil }
      it { should eql("dev123@example.com") }
    end

    describe '#institution_code' do
      subject { user.institution_code }
      it { should_not be_nil }
      it { should eql('NYUAD') }
    end

    describe '#institution' do
      subject(:institution) { user.institution }
      it { should_not be_nil }
      it { should be_a(Institutions::Institution) }
      describe '#code' do
        subject { institution.code }
        it { should_not be_nil }
        it { should eql(:NYUAD) }
      end
    end

    describe '#provider' do
      subject { user.provider }
      it { should_not be_nil }
      it { should eql('nyu_shibboleth') }
    end

    describe '#identities' do
      subject { user.identities }
      it { should be_blank }
    end
  end


  context "when email is invalid" do
    subject { build(:user, email: "dev123") }
    it { should be_a_new(User) }
    it { should be_valid } #We don't check for valid email address, leave it to provider
  end

  context "when username is duplicated" do
    # Set a username
    let(:username) { "dupusername" }
    # the create a user based on that name
    before { create(:user, username: username, email: "dupusername1@example.com") }
    # then build another user based on the name but with a different email
    subject { build(:user, username: username, email: "dupusername2@example.com") }
    it { should be_a(User) }
    it { should be_a_new(User) }
    it { should_not be_valid }
  end

  context "when email is duplicated" do
    # Set an email
    let(:email) { "dupemail@example.com" }
    # the create a user based on that email
    before { create(:user, username: "dupemailuser1", email: email) }
    # then build another user based on the email but with a different username
    subject { build(:user, username: "dupemailuser2", email: email) }
    it { should be_a(User) }
    it { should be_a_new(User) }
    it { should be_valid }
  end

  context "when institution code is invalid" do
    subject { build(:user, institution_code: 'INVALID') }
    it { should be_a(User) }
    it { should be_a_new(User) }
    it { should_not be_valid }
  end

  context "when OmniAuth::AuthHash is present" do
    let(:user) { create(:user, omniauth_hash_map: authhash_map(:aleph)) }
    subject { user }
    it { should be_a(User) }
    it { should_not be_a_new(User) }
    it { should be_valid }

    describe '#identities' do
      subject { user.identities }
      it { should_not be_blank }
    end

    Devise.omniauth_providers.each do |provider|
      describe "##{provider}_properties" do
        subject { user.send(:"#{provider}_properties") }

        it { should be_an(HashWithIndifferentAccess) }
      end
    end
  end
end

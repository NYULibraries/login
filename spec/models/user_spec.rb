require 'spec_helper'

describe User do
  context "when created with factory defaults" do
    subject { create(:user) }
    it { should be_valid }
  end

  context "when valid" do
    subject(:user) { build(:user, username: "dev123", email: "dev123@example.com") }

    describe '#username' do
      subject { user.username }
      it { should_not be_nil }
      it { should eql("dev123") }
    end

    describe '#email' do
      subject { user.email }
      it { should_not be_nil }
      it { should eql("dev123@example.com") }
    end

    describe '#password' do
      subject { user.password }
      it { should be_nil }
    end

    describe '#password_required?' do
      subject { user.password }
      it { should be_false }
    end
  end

  context "when email is invalid" do
    subject { build(:user, email: "dev123") }
    it { should_not be_valid }
  end

  context "when username is duplicated" do
    # Set a username
    let(:username) { "dupusername" }
    # the create a user based on that name
    before { create(:user, username: username, email: "dupusername1@example.com") }
    # then build another user based on the name but with a different email
    subject { build(:user, username: username, email: "dupusername2@example.com") }
    it { should_not be_valid }
  end

  context "when email is duplicated" do
    # Set an email
    let(:email) { "dupemail@example.com" }
    # the create a user based on that email
    before { create(:user, username: "dupemailuser1", email: email) }
    # then build another user based on the email but with a different username
    subject { build(:user, username: "dupemailuser2", email: email) }
    it { should_not be_valid }
  end
end

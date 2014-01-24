require 'spec_helper'

describe Identity do
  # Make sure the database is clean
  after { User.destroy_all }

  context "when created with factory defaults" do
    subject { create(:identity) }
    it { should be_valid }
  end

  context "when uid is nil" do
    subject { build(:identity, uid: nil) }
    it { should_not be_valid }
  end

  describe "when uid is not unique for the same provider" do
    before(:each) { create(:identity, provider: 'twitter') }
    subject { build(:identity, provider: 'twitter') }
    it { should_not be_valid }
  end

  context "when uid is not unique for different providers" do
    before(:each) { create(:identity, provider: 'twitter') }
    subject { build(:identity, provider: 'aleph') }
    it { should be_valid }
  end

  context "when provider is nil" do
    subject { build(:identity, provider: nil) }
    it { should_not be_valid }
  end

  context "when provider is not valid" do
    subject { build(:identity, provider: "invalid") }
    it { should_not be_valid }
  end

  context "when properties is nil" do
    subject { build(:identity, properties: nil) }
    it { should_not be_valid }
  end

  context "when valid" do
    subject(:identity) { build(:identity) }
    it { should be_valid }

    describe '#user' do
      subject(:user) { identity.user }
      it { should be_a User }

      describe '#username' do
        subject { user.username }
        it { should_not be_nil }
        it { should eql("developer") }
      end
    end

    describe '#provider' do
      subject { identity.provider }
      it { should_not be_nil }
      it { should eql("twitter") }
    end

    describe '#uid' do
      subject { identity.uid }
      it { should_not be_nil }
      it { should eql("1234567890") }
    end

    describe '#properties' do
      subject(:properties) { identity.properties }
      it { should_not be_nil }
      it { should be_a(Hash) }
      it { should_not be_empty }

      describe ':prop1' do
        subject { properties[:prop1] }
        it { should_not be_nil }
        it { should eql('Property 1') }
      end

      describe ':prop2' do
        subject { properties[:prop2] }
        it { should_not be_nil }
        it { should eql('Property 2') }
      end
    end
  end

  context "when Aleph identity" do
    context "when created with factory defaults" do
      subject { create(:aleph_identity) }
      it { should be_valid }
    end

    context "when uid is nil" do
      subject { build(:aleph_identity, uid: nil) }
      it { should_not be_valid }
    end

    context "when provider is nil" do
      subject { build(:aleph_identity, provider: nil) }
      it { should_not be_valid }
    end

    context "when properties is nil" do
      subject { build(:aleph_identity, properties: nil) }
      it { should_not be_valid }
    end

    context "when valid" do
      subject(:identity) { build(:aleph_identity) }
      it { should be_valid }

      describe '#user' do
        subject(:user) { identity.user }
        it { should be_a User }

        describe '#username' do
          subject { user.username }
          it { should_not be_nil }
          it { should eql("developer") }
        end
      end

      describe '#provider' do
        subject { identity.provider }
        it { should_not be_nil }
        it { should eql("aleph") }
      end

      describe '#uid' do
        subject { identity.uid }
        it { should_not be_nil }
        it { should eql("USERNAME") }
      end

      describe '#properties' do
        subject(:properties) { identity.properties }
        it { should_not be_nil }
        it { should be_a(Hash) }
        it { should_not be_empty }

        describe ':name' do
          subject { properties[:name] }
          it { should_not be_nil }
          it { should eql('USERNAME, TEST-RECORD') }
        end

        describe ':nickname' do
          subject { properties[:nickname] }
          it { should_not be_nil }
          it { should eql('USERNAME') }
        end

        describe ':email' do
          subject { properties[:email] }
          it { should_not be_nil }
          it { should eql('username@library.edu') }
        end

        describe ':extra' do
          subject(:extra) { properties[:extra] }
          it { should_not be_nil }
          it { should be_a(Hash) }
          it { should_not be_empty }

          describe ':raw_info' do
            subject(:raw_info) { extra[:raw_info] }
            it { should_not be_nil }
            it { should be_a(Hash) }
            it { should_not be_empty }

            describe ':bor_auth' do
              subject(:bor_auth) { raw_info[:bor_auth] }
              it { should_not be_nil }
              it { should be_a(Hash) }
              it { should_not be_empty }

              describe ':z303' do
                subject(:z303) { bor_auth[:z303] }
                it { should_not be_nil }
                it { should be_a(Hash) }
                it { should_not be_empty }

                describe ':z303_id' do
                  subject(:z303_id) { z303[:z303_id] }
                  it { should_not be_nil }
                  it { should eql("USERNAME") }
                end
              end
            end
          end
        end
      end
    end
  end
end

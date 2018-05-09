require 'rails_helper'

describe Identity do
  context "when created with factory defaults" do
    subject { create(:identity) }
    it { is_expected.to be_valid }
  end

  context "when uid is nil" do
    subject { build(:identity, uid: nil) }
    it { is_expected.to_not be_valid }
  end

  context "when uid is not unique for the same provider" do
    let!(:user1) { create(:user, username: Faker::Internet.user_name) }
    let!(:user2) { create(:user, username: Faker::Internet.user_name) }
    let(:identity) { build(:identity, provider: 'twitter', user: user) }
    before { create(:identity, provider: 'twitter', user: user1) }
    subject { identity }
    context 'and the user is the same' do
      let(:user) { user1 }
      it { is_expected.to_not be_valid }
    end
    context 'but the user is different' do
      let(:user) { user2 }
      it { is_expected.to be_valid }
    end
  end

  context "when uid is not unique for different providers" do
    before { create(:identity, provider: 'twitter') }
    subject { create(:identity, provider: 'aleph') }
    it { is_expected.to be_valid }
  end

  context "when provider is nil" do
    subject { build(:identity, provider: nil) }
    it { is_expected.to_not be_valid }
  end

  context "when provider is nyu_shibboleth" do
    subject { build(:identity, provider: "nyu_shibboleth") }
    it { is_expected.to be_valid }
  end

  context "when provider is not valid" do
    subject { build(:identity, provider: "invalid") }
    it { is_expected.to_not be_valid }
  end

  context "when provider is shibboleth" do
    subject { build(:identity, provider: "shibboleth") }
    it { is_expected.to_not be_valid }
  end

  context "when properties is nil" do
    subject { build(:identity, properties: nil) }
    it { is_expected.to_not be_valid }
  end

  context "when valid" do
    subject(:identity) { build(:identity) }
    it { is_expected.to be_valid }

    describe '#provider' do
      subject { identity.provider }
      it { is_expected.to_not be_nil }
      it { is_expected.to eql("twitter") }
    end

    describe '#uid' do
      subject { identity.uid }
      it { is_expected.to_not be_nil }
      it { is_expected.to eql("1234567890") }
    end

    describe '#properties' do
      subject(:properties) { identity.properties }
      it { is_expected.to_not be_nil }
      it { is_expected.to be_a(Hash) }
      it { is_expected.to_not be_empty }

      describe ':prop1' do
        subject { properties["prop1"] }
        it { is_expected.to_not be_nil }
        it { is_expected.to eql('Property 1') }
      end

      describe ':prop2' do
        subject { properties["prop2"] }
        it { is_expected.to_not be_nil }
        it { is_expected.to eql('Property 2') }
      end
    end
  end

  context "when Aleph identity" do
    context "when created with factory defaults" do
      subject { create(:aleph_identity) }
      it { is_expected.to be_valid }
    end

    context "when uid is nil" do
      subject { build(:aleph_identity, uid: nil) }
      it { is_expected.to_not be_valid }
    end

    context "when provider is nil" do
      subject { build(:aleph_identity, provider: nil) }
      it { is_expected.to_not be_valid }
    end

    context "when properties is nil" do
      subject { build(:aleph_identity, properties: nil) }
      it { is_expected.to_not be_valid }
    end

    context "when valid" do
      subject(:identity) { build(:aleph_identity) }
      it { is_expected.to be_valid }

      describe '#provider' do
        subject { identity.provider }
        it { is_expected.to_not be_nil }
        it { is_expected.to eql("aleph") }
      end

      describe '#uid' do
        subject { identity.uid }
        it { is_expected.to_not be_nil }
        it { is_expected.to eql("USERNAME") }
      end

      describe '#properties' do
        subject(:properties) { identity.properties }
        it { is_expected.to_not be_nil }
        it { is_expected.to be_a(Hash) }
        it { is_expected.to_not be_empty }

        describe ':name' do
          subject { properties["name"] }
          it { is_expected.to_not be_nil }
          it { is_expected.to eql('USERNAME, TEST-RECORD') }
        end

        describe ':nickname' do
          subject { properties["nickname"] }
          it { is_expected.to_not be_nil }
          it { is_expected.to eql('USERNAME') }
        end

        describe ':email' do
          subject { properties["email"] }
          it { is_expected.to_not be_nil }
          it { is_expected.to eql('username@library.edu') }
        end

        describe ':extra' do
          subject(:extra) { properties["extra"] }
          it { is_expected.to_not be_nil }
          it { is_expected.to be_a(Hash) }
          it { is_expected.to_not be_empty }

          describe ':raw_info' do
            subject(:raw_info) { extra["raw_info"] }
            it { is_expected.to_not be_nil }
            it { is_expected.to be_a(Hash) }
            it { is_expected.to_not be_empty }

            describe ':bor_auth' do
              subject(:bor_auth) { raw_info["bor_auth"] }
              it { is_expected.to_not be_nil }
              it { is_expected.to be_a(Hash) }
              it { is_expected.to_not be_empty }

              describe ':z303' do
                subject(:z303) { bor_auth["z303"] }
                it { is_expected.to_not be_nil }
                it { is_expected.to be_a(Hash) }
                it { is_expected.to_not be_empty }

                describe ':z303_id' do
                  subject(:z303_id) { z303["z303_id"] }
                  it { is_expected.to_not be_nil }
                  it { is_expected.to eql("USERNAME") }
                end
              end
            end
          end
        end
      end
    end
  end
end

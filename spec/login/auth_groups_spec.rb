require 'rails_helper'

describe Login::AuthGroups do

  let(:user) { create(:user) }
  let(:auth_groups) { Login::AuthGroups.new(user) }

  describe '.new' do
    subject { auth_groups }
    it { is_expected.to be_instance_of Login::AuthGroups }
  end

  describe '#auth_groups' do
    subject { auth_groups.auth_groups }
    context 'when user is neither an undergraduate or graduate' do
      it { is_expected.to eql [] }
    end
    context 'when user is an undergraduate student' do
      let(:user) { create(:ny_undergraduate_user) }
      it { is_expected.to eql ["undergraduate"] }
    end
    context 'when user is a graduate student' do
      let(:user) { create(:ny_graduate_user) }
      it { is_expected.to eql ["graduate"] }
    end
  end

end

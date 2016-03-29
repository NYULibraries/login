require 'rails_helper'
describe "NYU Shibboleth Login" do
  before { https!; get("/users/auth/nyu_shibboleth/callback?auth_type=nyu", nil, environment) }
  context "when there is no Shibboleth session in the SP " do
    let(:environment) { nil }
    describe 'OmniAuth::AuthHash' do
      subject(:omniauth_hash) { @request.env['omniauth.auth'] if @request.present? }
      it { should be_blank }
    end
  end
  context "when there is a Shibboleth session in the SP " do
    let(:environment) { shibboleth_env }
    describe 'User creation' do
      it "should create the User and assign it to @User" do
        expect(assigns(:user)).to be_a(User)
        expect(assigns(:user)).not_to be_nil
        expect(assigns(:user)).not_to be_a_new(User)
        expect(assigns(:user).username).to eq('dev1')
      end
    end
    describe 'OmniAuth::AuthHash' do
      subject(:omniauth_hash) { @request.env['omniauth.auth'] if @request.present? }
      it { should_not be_blank }
      describe '#uid' do
        subject { omniauth_hash.uid }
        it { should_not be_blank }
        it { should eq('dev1') }
      end
      describe '#provider' do
        subject { omniauth_hash.provider }
        it { should_not be_blank }
        it { should eq('nyu_shibboleth') }
      end
      describe '#info' do
        subject(:info) { omniauth_hash.info }
        it { should_not be_blank }
        describe '#name' do
          subject { info.name }
          it { should_not be_blank }
          it { should eq('Dev Eloper') }
        end
        describe '#email' do
          subject { info.email }
          it { should_not be_blank }
          it { should eq('dev.eloper@nyu.edu') }
        end
        describe '#nickname' do
          subject { info.nickname }
          it { should_not be_blank }
          it { should eq('Dev') }
        end
        describe '#first_name' do
          subject { info.first_name }
          it { should_not be_blank }
          it { should eq('Dev') }
        end
        describe '#last_name' do
          subject { info.last_name }
          it { should_not be_blank }
          it { should eq('Eloper') }
        end
      end
      describe '#extra' do
        subject(:extra) { omniauth_hash.extra }
        it { should_not be_blank }
        it { should_not be_empty }
        describe '#raw_info' do
          subject(:raw_info) { extra.raw_info }
          it { should_not be_blank }
          describe '#nyuidn' do
            subject { raw_info.nyuidn }
            it { should_not be_blank }
            it { should eq('1234567890') }
          end
          describe '#entitlement' do
            subject { raw_info.entitlement }
            it { should_not be_blank }
            it { should eq('urn:mace:nyu.edu:entl:lib:eresources;urn:mace:incommon:entitlement:common:1') }
          end
        end
      end
    end
  end
end

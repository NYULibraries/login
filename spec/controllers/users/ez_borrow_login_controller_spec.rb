require 'rails_helper'
describe Users::EzBorrowLoginController do
  subject { get :ezborrow_login, params: params }

  LS_BY_INSTITUTION = {
    'nyu'    => 'NYU',
    'nyuad'  => 'NYU',
    'nyush'  => 'NYU',
    'hsl'    => 'NYU',
    'ns'     => 'THENEWSCHOOL',
  }.freeze
  SKINNED_INSTITUTIONS = %w(nyu nyush nyuad ns).freeze
  UNSKINNED_INSTITUTIONS = %w(cu nysid).freeze
  STATUS_BY_INSTITUTION = {
    'nyu' => '50',
    'nyuad' => '80',
    'nyush' => '20',
    'hsl' => '60',
    'ns' => '31',
    'cu' => '666',
    'nysid' => '666',
  }.freeze

  let(:bor_status) { "999" }
  let(:institution_code) { "NYUFAKE" }
  let(:identifier) { "BOR_ID" }
  let(:params) { {} }
  let(:ezborrow_user) { create(:ezborrow_user) }
  let(:query) { 'ti="lean in" and au="sandberg"' }

  before do
    User.
      any_instance.stub(:aleph_properties).
      and_return(
        HashWithIndifferentAccess.new(
          patron_status: bor_status,
          institution_code: institution_code,
          identifier: identifier,
        )
      )

    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET /ezborrow/:institution' do
    render_views false
    context 'when not logged in' do
      it { should be_successful }
      it { should render_template "wayf/index" }

      context 'when a valid institution' do
        SKINNED_INSTITUTIONS.each do |inst|
          describe "#{inst} valid route is specified" do
            let(:params) { { institution: inst } }

            it { should be_successful }
            it { should render_template "wayf/index" }
          end
        end
      end

      context 'when an unskinned institution' do
        UNSKINNED_INSTITUTIONS.each do |inst|
          describe "#{inst} invalid route is specified" do
            let(:params) { { institution: inst } }

            it { should be_successful }
            it { should render_template "wayf/index" }
          end
        end
      end

      describe 'with a query' do
        let(:params) { { query: query } }

        it { should be_successful }
        it { should render_template "wayf/index" }
      end
    end

    context 'when logged in' do
      login_user
      before { @current_user = ezborrow_user }

      let(:provider) { 'aleph' }

      context "when the user is from a valid ezborrow institution" do
        describe 'without a query' do
          SKINNED_INSTITUTIONS.each do |user_institution|
            [*SKINNED_INSTITUTIONS, nil].each do |route_institution|
              let(:bor_status) { STATUS_BY_INSTITUTION[user_institution] }
              let(:institution_code) { user_institution }
              let(:params) { { institution: route_institution } }
              let(:target_ls) { LS_BY_INSTITUTION[user_institution] }

              describe "when a #{user_institution} user at #{route_institution}" do
                it { should be_redirect }
                it { should redirect_to "https://ezb.relaisd2d.com/?LS=#{target_ls}&PI=BOR_ID" }
              end
            end
          end
        end

        context 'with a query and valid route institution' do
          SKINNED_INSTITUTIONS.each do |user_institution|
            [*SKINNED_INSTITUTIONS, nil].each do |route_institution|
              let(:bor_status) { STATUS_BY_INSTITUTION[user_institution] }
              let(:institution_code) { user_institution }
              let(:params) { { query: query, institution: route_institution } }
              let(:target_ls) { LS_BY_INSTITUTION[user_institution] }

              describe "when a #{user_institution} user at #{route_institution}" do
                it { should be_redirect }
                it { should redirect_to "https://ezb.relaisd2d.com/?LS=#{target_ls}&PI=BOR_ID&query=ti%3D%22lean%20in%22%20and%20au%3D%22sandberg%22" }
              end
            end
          end
        end
      end

      context "when the user is from an invalid ezborrow institution" do
        let(:bor_status) { STATUS_BY_INSTITUTION['cu'] }

        SKINNED_INSTITUTIONS.each do |route_institution|
          describe "when an invalid user at #{route_institution}" do
            it { should be_redirect }
            it { should redirect_to 'https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized' }
          end
        end
      end
    end
  end
end

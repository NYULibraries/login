require 'rails_helper'
describe UsersController do
  subject { get :ezborrow_login, params: params }

  LS_DICT = {
      'nyu'    => 'NYU',
      'nyuad'  => 'NYU',
      'nyush'  => 'NYU',
      'ns'     => 'THENEWSCHOOL',
  }
  VALID_INSTITUTIONS = %w(nyu nyush nyuad ns).freeze
  INVALID_INSTITUTIONS = %w(cu nysid).freeze

  let(:flat_file) { "spec/data/ezborrow/patrons-UTF-8-ezborrow-nyu.dat" }
  let(:params) { {} }

  before do
    ENV['FLAT_FILE'] = flat_file
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET /ezborrow/:institution' do
    render_views false
    context 'when not logged in' do
      it { should be_successful }
      it { should render_template "wayf/index" }

      context 'when a valid institution' do
        VALID_INSTITUTIONS.each do |inst|
          describe "#{inst} valid route is specified" do
            let(:params) { { institution: inst } }

            it { should be_successful }
            it { should render_template "wayf/index" }
          end
        end
      end

      context 'when an invalid institution' do
        INVALID_INSTITUTIONS.each do |inst|
          describe "#{inst} invalid route is specified" do
            let(:params) { { institution: inst } }

            it { should be_successful }
            it { should render_template "wayf/index" }
          end
        end
      end

      describe 'with a query' do
        let(:params) { { query: 'the astd management development handbook' } }

        it { should be_successful }
        it { should render_template "wayf/index" }
      end
    end

    context 'when logged in' do
      login_user
      let(:provider) { 'aleph' }

      context "when the user is from a valid ezborrow institution" do
        describe 'without a query' do
          let(:params) { {} }
          let(:target_ls) { LS_DICT[user_institution] }

          VALID_INSTITUTIONS.each do |user_institution|
            [*VALID_INSTITUTIONS, nil].each do |route_institution|
              let(:flat_file) { "spec/data/ezborrow/patrons-UTF-8-ezborrow-#{user_institution}.dat" }
              let(:params) { { query: nil, institution: route_institution } }
              let(:target_ls) { LS_DICT[user_institution] }

              describe "when a #{user_institution} user at #{route_institution}" do
                it { should be_redirect }
                it { should redirect_to "https://e-zborrow.relaisd2d.com/service-proxy/?command=mkauth&LS=#{target_ls}&PI=BOR_ID&query=" }
              end
            end
          end
        end

        context 'with a query and valid route institution' do
          VALID_INSTITUTIONS.each do |user_institution|
            [*VALID_INSTITUTIONS, nil].each do |route_institution|
              let(:flat_file) { "spec/data/ezborrow/patrons-UTF-8-ezborrow-#{user_institution}.dat" }
              let(:params) { { query: 'the astd management development handbook', institution: route_institution } }
              let(:target_ls) { LS_DICT[user_institution] }

              describe "when a #{user_institution} user at #{route_institution}" do
                it { should be_redirect }
                it { should redirect_to "https://e-zborrow.relaisd2d.com/service-proxy/?command=mkauth&LS=#{target_ls}&PI=BOR_ID&query=the+astd+management+development+handbook" }
              end
            end
          end
        end
      end

      context "when the user is from an invalid ezborrow institution" do
        VALID_INSTITUTIONS.each do |route_institution|
          describe "when an invalid user at #{route_institution}" do
            let(:flat_file) { "spec/data/patrons-UTF-8.dat" }

            it { should be_redirect }
            it { should redirect_to 'https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized' }
          end
        end
      end
    end
  end
end

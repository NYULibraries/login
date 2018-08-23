require 'rails_helper'
describe UsersController do
  subject { get :ezborrow_login, params: params }

  let(:flat_file) { "spec/data/patrons-UTF-8-ezborrow.dat" }
  let(:params) { Hash.new }

  before do
    ENV['FLAT_FILE'] = flat_file
  end

  describe 'GET /ezborrow/:institution' do
    context 'when not logged in' do
      it { should be_redirect }
      it { should redirect_to '/login/nyu?referrer=ezborrow' }

      context 'and institution route is specified' do
        describe 'nyu' do
          let(:params) { { institution: 'nyu' } }
          it { should be_redirect }
          it { should redirect_to '/login/nyu?referrer=ezborrow' }
        end

        describe "nyuad" do
          let(:params) { { institution: 'nyuad' } }
          it { should be_redirect }
          it { should redirect_to '/login/nyuad?referrer=ezborrow' }
        end

        describe "nyush" do
          let(:params) { { institution: 'nyush' } }
          it { should be_redirect }
          it { should redirect_to '/login/nyush?referrer=ezborrow' }
        end

        describe "ns" do
          let(:params) { { institution: 'ns' } }
          it { should be_redirect }
          it { should redirect_to '/login/ns?referrer=ezborrow' }
        end

        context 'an invalid ezborrow institution' do
          let(:params) { { institution: 'ns' } }
          it { should be_redirect }
          it { should redirect_to '/login/ns?referrer=ezborrow' }
        end
      end
    end

    context 'when logged in' do
      login_user
      render_views false
      let(:provider) { 'aleph' }
      context 'when user\'s institution is a valid ezborrow institution' do
        context 'when borrow status is valid' do
          it { should be_redirect }
          it { should redirect_to 'https://e-zborrow.relaisd2d.com/index.html' }

          context 'with a query' do
            let(:params) { { query: 'the astd managemenet development handbook' } }

            it { should be_redirect }
            it { should redirect_to "https://e-zborrow.relaisd2d.com/service-proxy/?command=mkauth&LS=NYU&PI=BOR_ID&query=the+astd+managemenet+development+handbook" }
          end
        end

        context 'when borrow status is unauthorized' do
          let(:flat_file) { "spec/data/patrons-UTF-8.dat" }

          it { should be_redirect }
          it { should redirect_to 'https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized' }
        end

        context 'when institution specified' do
          context 'nyu' do
            let(:params) { { institution: 'nyu' } }

            it { should be_redirect }
            it { should redirect_to 'https://e-zborrow.relaisd2d.com/index.html' }
          end

          context 'ns' do
            let(:params) { { institution: 'ns' } }

            it { should be_redirect }
            it { should redirect_to 'https://e-zborrow.relaisd2d.com/index.html' }
          end

          context 'cu' do
            let(:params) { { institution: 'cu' } }

            it { should be_redirect }
            it { should redirect_to 'https://e-zborrow.relaisd2d.com/index.html' }
          end
        end
      end

      context 'when user institution is not a valid ezborrow institution' do
          let(:flat_file) { "spec/data/patrons-UTF-8-ns.dat" }

          it { should be_redirect }
          it { should redirect_to 'https://library.nyu.edu/errors/ezborrow-library-nyu-edu/unauthorized' }
        end
    end
  end
end

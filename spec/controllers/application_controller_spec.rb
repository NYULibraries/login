require 'rails_helper'
describe ApplicationController do
  let(:"Hello world!") { "Hello world!" }

  controller do
    before_action :require_login!

    def index
      render text: "Hello world!"
    end
  end

  describe '#require_login!' do
    subject { response }

    before { get :index }

    context 'when not logged in' do
      it { should be_successful }
      it { should render_template "wayf/index" }

      it 'assigns @redirect_uri' do
        expect(assigns(:redirect_uri)).not_to be_nil
        expect(assigns(:redirect_uri)).to eql "/anonymous"
      end
    end

    # context 'when logged in' do
    #   login_user
    #   render_views
    #
    #   it { should be_successful }
    #   its(:body) { should eql "Hello world!" }
    # end
  end
end

describe RootController do
  describe '#root_url_redirect' do
    login_user
    subject { get :root }
    context 'when BOBCAT_URL and PDS_URL environment variables are not set' do
      before { stub_const('ENV', ENV.to_hash.merge('BOBCAT_URL' => nil)) }
      before { stub_const('ENV', ENV.to_hash.merge('PDS_URL' => nil)) }

      it { should be_redirect }
      it { should redirect_to "https://pds.library.nyu.edu/pds?func=load-login&institute=NYU&calling_system=primo&url=http%3a%2f%2fbobcat.library.nyu.edu%2fprimo_library%2flibweb%2faction%2fsearch.do%3fdscnt%3d0%26amp%3bvid%3dNYU&func=load-login&amp;institute=NYU&amp;calling_system=primo&amp;url=http://bobcat.library.nyu.edu:80/primo_library/libweb/action/login.do" }
    end
  end
end

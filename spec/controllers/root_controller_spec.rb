describe RootController do
  describe '#healthcheck' do
    subject { get :healthcheck }
    let(:healthcheck_body) {
      { success: true }.to_json
    }
    its(:body) { is_expected.to eql healthcheck_body }
    it 'should be a JSON response' do
      expect { subject.header['Content-Type'].to include 'application/json' }
    end
  end
end

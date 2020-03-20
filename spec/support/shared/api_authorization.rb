shared_examples_for 'API Authenticable' do
  context 'when unauthorized' do
    it 'return 401 status if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'return 401 status if access_token is valid' do
      do_request(access_token: '1234')
      expect(response.status).to eq 401
    end
  end
end

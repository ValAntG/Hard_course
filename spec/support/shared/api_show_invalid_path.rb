shared_examples_for 'API show invalid path' do
  context 'when authorized invalid path' do
    subject(:parsed_response) { JSON.parse(response.body) }

    before { invalid_path }

    it { expect(parsed_response['status']).to eq('error') }
    it { expect(parsed_response['code']).to eq(404) }
    it { expect(parsed_response['message']).to eq("Can't find question") }
  end
end

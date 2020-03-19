shared_examples_for 'API index when authorized' do |attributes|
  before { index_authorized }

  it { expect(response).to be_successful }
  it { expect(response.body).to have_json_size(size).at_path(have_json_at_path) }

  attributes.each do |attr|
    it { expect(response.body).to be_json_eql(object.send(attr.to_sym).to_json).at_path(path + attr.to_s) }
  end
end

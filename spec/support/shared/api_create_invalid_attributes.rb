shared_examples_for 'API create invalid attributes' do
  before { create_invalid_attr(attributes) }

  it { expect { create_invalid_attr(attributes) }.not_to change(object, :count) }
  it { expect(response).not_to be_successful }
  it { expect(response.status).to eq 422 }
end

require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  let!(:user) { create :user }
  let!(:question) { create :question }

  before do
    stub_connection user_id: user.id
  end

  it 'subscribes to a stream is provided' do
    subscribe(question_id: question.id)

    expect(subscription).to be_confirmed
    expect(streams).to include("questions/#{question.id}/answers")
  end
end

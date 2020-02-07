require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  let!(:user) { create :user }
  let!(:question) { create :question }

  before do
    stub_connection user_id: user.id
  end

  context 'when subscribes to' do
    it 'a stream is provided' do
      subscribe(question_id: question.id)
      expect(streams).to include("questions/#{question.id}/answers")
    end

    it 'be confirmed' do
      subscribe(question_id: question.id)
      expect(subscription).to be_confirmed
    end
  end
end

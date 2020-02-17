require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  let(:user) { create :user }
  let(:question) { create :question }

  before do
    stub_connection user_id: user.id
    subscribe(question_id: question.id)
  end

  context 'when subscribes to' do
    it 'a stream is provided' do
      expect(streams).to include("questions/#{question.id}/comments")
    end

    it 'be confirmed' do
      expect(subscription).to be_confirmed
    end
  end
end

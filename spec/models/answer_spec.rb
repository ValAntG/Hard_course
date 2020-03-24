require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many :attachments }
  it { should have_many :comments }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  describe 'reputation' do
    subject(:answer) { build(:answer, user: user, question: question) }

    let(:question) { create(:question) }
    let(:user) { create(:user) }

    it 'calculate reputation after creating' do
      expect(Reputation).to receive(:calculate).with(answer)
      answer.save!
    end

    it 'not calculate reputation after updating' do
      answer.save!
      expect(Reputation).not_to receive(:calculate)
      answer.update(body: '121')
    end
  end
end

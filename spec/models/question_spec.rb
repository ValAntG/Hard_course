require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to :user }
  it { should have_many :answers }
  it { should have_many :attachments }
  it { should have_many :comments }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  describe 'reputation' do
    subject(:question) { build(:question, user: user) }

    let(:user) { create(:user) }

    it 'should calculate reputation after creating' do
      expect(Reputation).to have_received(:calculate).with(question)
      question.save!
    end

    it 'should not calculate reputation after updating' do
      question.save!
      expect(Reputation).not_to have_received(:calculate)
      question.update(title: '121')
    end

    it 'should save user reputation' do
      allow(Reputation).to have_received(:calculate)
    end
  end
end

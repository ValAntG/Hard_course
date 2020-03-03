require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, user: user) }
    let(:question_other_user) { create(:question, user: other_user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:answer_other_user) { create(:answer, question: question, user: other_user) }
    let(:comment) { create(:comment, commentable: question, user: user) }
    let(:comment_other_user) { create(:comment, commentable: question, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, question_other_user, user: user }
    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, answer_other_user, user: user }
    it { should be_able_to :update, comment, user: user }
    it { should_not be_able_to :update, comment_other_user, user: user }
    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, question_other_user, user: user }
    it { should be_able_to :destroy, answer, user: user }
    it { should_not be_able_to :destroy, answer_other_user, user: user }
    it { should be_able_to :destroy, comment, user: user }
    it { should_not be_able_to :destroy, comment_other_user, user: user }
  end
end

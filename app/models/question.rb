class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :update_reputation

  private

  def update_reputation
    self.delay.calculate_reputation
  end

  def calculate_reputation
    reputation = Reputation.calculate(self)
    self.user.update(reputation: reputation)
  end
end

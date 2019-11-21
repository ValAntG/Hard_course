class Question < ApplicationRecord
  has_many :answers
  belongs_to :user
  has_many :attachments
  validates :title, presence: true
  validates :body, presence: true
end

class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :created_at, :updated_at
  has_many :attachments
  has_many :comments
end

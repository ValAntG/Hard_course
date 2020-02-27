class AnswerForm < ApplicationForm
  attr_accessor :body, :attachments, :user_id, :question_id, :answer

  validates :question_id, presence: true

  delegate :model_name, :persisted?, to: :answer

  def initialize(attributes = {})
    super
    @answer = answer
    @answer.body = body
    @answer.question_id = question_id
    @answer.user_id = user_id
    @attachments ||= {}
  end

  def save
    update_form_attributes(@answer)
  end

  alias update save
end

class AnswerForm < ApplicationForm
  attr_accessor :id, :body, :attachments, :user_id, :question_id
  attr_reader :answer

  validates :question_id, presence: true

  def initialize(attributes = {})
    super
    @attachments ||= { attachments: nil }
    @answer ||= Answer.new
  end

  delegate :model_name, :id, :body, :user_id, :persisted?, :attachments, to: :answer

  def save
    @answer.body = @body
    @answer.question_id = @question_id
    @answer.user_id = @user_id
    update_form_attributes(@answer)
  end

  def update
    @answer = Answer.find(@id)
    @answer.body = @body
    update_form_attributes(@answer)
  end
end

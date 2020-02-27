class QuestionForm < ApplicationForm
  attr_accessor :body, :title, :attachments, :user_id, :question, :id

  validates :title, presence: true

  delegate :model_name, :id, :persisted?, to: :question

  def initialize(attributes = {})
    super
    @question = question
    @question.title = title
    @question.body = body
    @question.user_id = user_id
    @id = question.id
    @attachments ||= {}
  end

  def save
    update_form_attributes(@question)
  end

  alias update save
end

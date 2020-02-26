class QuestionForm < ApplicationForm
  attr_accessor :id, :title, :body, :attachments, :user_id
  attr_reader :question

  validates :title, presence: true

  def initialize(attributes = {})
    super
    @attachments ||= { attachments: nil }
    @question = Question.new
  end

  delegate :model_name, :id, :title, :body, :user_id, :persisted?, :attachments, to: :question

  def save
    @question.title = @title
    @question.body = @body
    @question.user_id = @user_id
    update_form_attributes(@question)
  end

  def update
    @question = Question.find(@id)
    @question.title = @title
    @question.body = @body
    update_form_attributes(@question)
  end
end

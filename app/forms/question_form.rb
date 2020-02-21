class QuestionForm < ApplicationForm
  attr_accessor :id, :title, :body, :attachments, :user_id

  attr_reader :question

  validates :title, presence: true

  def initialize(attributes = {})
    super
    @id ? @question = Question.find(@id) : @question = Question.new(user_id: @user_id)
    @attachments ||= { attachments: nil }
  end

  delegate :model_name, :id, :title, :body, :user_id, :persisted?, :attachments, to: :question

  private

  def update_form_attributes
    @question.title = @title
    @question.body = @body
    if valid?
      @question.save
      create_attachment(@question) if @attachments[:files]
      true
    else
      false
    end
  end
end

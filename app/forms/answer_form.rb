class AnswerForm < ApplicationForm
  attr_accessor :id, :body, :attachments, :user_id, :question_id
  attr_reader :answer

  validates :question_id, presence: true

  def initialize(attributes = {})
    super
    @id ? @answer = Answer.find(@id) : @answer = Answer.new(question_id: @question_id, user_id: @user_id)
    @attachments ||= { attachments: nil }
  end

  delegate :model_name, :id, :body, :user_id, :persisted?, :attachments, to: :answer

  private

  def update_form_attributes
    @answer.body = @body
    if valid?
      @answer.save
      create_attachment(@answer) if @attachments[:files]
      true
    else
      false
    end
  end
end

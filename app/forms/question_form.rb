class QuestionForm
  include ActiveModel::Model
  include Virtus

  attribute :title, String
  attribute :body, String
  attribute :attachments, Hash[Symbol => Integer]
  attribute :user_id
  attribute :id

  attr_reader :attachments, :question

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  def save
    if valid?
      save_question
      save_attachment unless attachments.empty?
      true
    else
      false
    end
  end

  def update
    if valid?
      update_question
      save_attachment unless attachments.empty?
      true
    else
      del_attachment if attachments[:_destroy]
      false
    end
  end

  private

  def save_question
    @question = Question.create!(title: title, body: body, user_id: user_id)
  end

  def update_question
    @question = Question.find(id)
    @question.update(title: title, body: body)
  end

  def save_attachment
    attachments[:files].each do |file|
      @question.attachments.create!(file: file)
    end
  end

  def del_attachment
    Attachment.find(attachments[:id]).delete
  end
end

class AnswerForm
  include ActiveModel::Model
  include Virtus

  attribute :body, String
  attribute :attachments, Hash[Symbol => Integer]
  attribute :user_id
  attribute :question_id
  attribute :id

  attr_reader :attachments, :answer

  validates :body, presence: true
  validates :user_id, presence: true
  validates :question_id, presence: true

  def save
    if valid?
      save_answer
      save_attachment unless attachments.empty?
      true
    else
      false
    end
  end

  def update
    if valid?
      update_answer
      save_attachment unless attachments.empty?
      true
    else
      del_attachment if attachments[:_destroy]
      false
    end
  end

  private

  def save_answer
    @answer = Answer.create!(body: body, user_id: user_id, question_id: question_id)
  end

  def update_answer
    @answer = Answer.find(id)
    @answer.update(body: body)
  end

  def save_attachment
    attachments[:files].each do |file|
      @answer.attachments.create!(file: file)
    end
  end

  def del_attachment
    Attachment.find(attachments[:id]).delete
  end
end

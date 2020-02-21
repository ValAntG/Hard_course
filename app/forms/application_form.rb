class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Naming

  validates :body, :user_id, presence: true

  def save
    update_form_attributes
  end

  def update
    @attachments[:_destroy] ? del_attachment : update_form_attributes
  end

  private

  def del_attachment
    Attachment.find(@attachments[:id]).delete
  end

  def create_attachment(attachmentable)
    @attachments[:files].each do |file|
      attachmentable.attachments.create(file: file)
    end
  end
end

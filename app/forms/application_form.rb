class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Naming

  validates :body, :user_id, presence: true

  private

  def create_attachment(element)
    @attachments[:files].each do |file|
      element.attachments.create(file: file)
    end
  end

  def del_attachment
    @attachments[:delete].each_key do |id|
      Attachment.find(id).destroy
    end
  end

  def update_form_attributes(element)
    if valid?
      element.save
      del_attachment if @attachments[:delete]
      create_attachment(element) if @attachments[:files]
      true
    else
      false
    end
  end
end

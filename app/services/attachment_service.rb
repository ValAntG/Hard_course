module AttachmentService
  def self.attachments_load(element, params)
    params[:attachments]['files'].each do |attachment|
      @attachment = element.attachments.create!(file: attachment)
    end
  end

  def self.element_update(element, params)
    element.attachments.find_by(id: params[:attachments][:id]).destroy if params.dig(:attachments, :_destroy)
    attachments_load(element, params) if params.dig(:attachments, :files)
    element.update(params.permit(:title, :body)) if params.dig(:body)
  end
end

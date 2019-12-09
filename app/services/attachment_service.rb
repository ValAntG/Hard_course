module AttachmentService
  def self.attachments_load(element, attachments_params)
    attachments_params['file'].each do |attachment|
      @attachment = element.attachments.create!(file: attachment)
    end
  end

  def self.element_update(element, attachments_params, element_params)
    if attachments_params && attachments_params[:_destroy]
      element.attachments.find_by(id: attachments_params[:id]).destroy
    end
    attachments_load(element, attachments_params) if attachments_params && attachments_params[:file]
    element.update(element_params) if element_params
  end
end

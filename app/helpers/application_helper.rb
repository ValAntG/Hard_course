module ApplicationHelper
  def attachments_path_build(element, attachment)
    case element
    when Question
      question_path(element.id, attachment_delete_params(element, attachment))
    when Answer
      answer_path(element.id, attachment_delete_params(element, attachment))
    end
  end

  private

  def attachment_delete_params(element, attachment)
    { element.class.name.downcase!.to_sym => { attachments: { id: attachment.id, _destroy: true } } }
  end
end

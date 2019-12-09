module ApplicationHelper
  def attachments_path_build(element, attachment)
    attachment_delete_params = { attachments: { id: attachment.id, _destroy: true } } if attachment.id
    case element
    when Question
      question_path(element.id, attachment_delete_params)
    when Answer
      question_answer_path(element.question.id, element.id, attachment_delete_params)
    end
  end
end

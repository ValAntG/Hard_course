class AnswerMailer < ApplicationMailer
  default from: 'NIXSolutions.school@mail.com'

  def reply(answer)
    @answer = answer
    @question = @answer.question
    @user = @question.user

    mail to: @user.email, subject: 'New answer to a question'
  end
end

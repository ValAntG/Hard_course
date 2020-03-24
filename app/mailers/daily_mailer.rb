class DailyMailer < ApplicationMailer
  default from: 'NIXSolutions.school@mail.com'

  def digest(user)
    now = Time.zone.now
    @questions = Question.where(created_at: now - 1.day..now)
    @user = user

    mail to: user.email, subject: 'Daily digest'
  end
end

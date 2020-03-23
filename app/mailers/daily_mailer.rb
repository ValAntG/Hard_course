class DailyMailer < ApplicationMailer
  default from: 'NIXSolutions.school@mail.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user)
    now = Time.zone.now
    @questions = Question.where(created_at: now - 1.day..now)
    @user = user

    mail to: user.email, subject: 'Daily digest'
  end
end

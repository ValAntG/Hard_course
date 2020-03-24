class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook google_oauth2]
  has_many :questions
  has_many :answers
  has_many :authorizations

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    user = find_or_create_user(auth)
    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end

  def self.find_or_create_user(auth)
    email = auth.info[:email]
    user = User.find_by(email: email)
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.delay.digest(user)
    end
  end
end

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    return unless @user.persisted?

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
  end

  def google_oauth2
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    return unless @user.persisted?

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
  end
end

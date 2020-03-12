require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  include CanCan
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  # This code applies to gem Pundit
  # check_authorization

  # include Pundit
  # protect_from_forgery
  #
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  #
  # private
  #
  # def user_not_authorized
  #   flash[:warning] = 'You are not authorized to perform this action.'
  #   redirect_to(request.referrer || root_path)
  # end
end

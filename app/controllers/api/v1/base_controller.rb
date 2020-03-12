module Api
  module V1
    class BaseController < ApplicationController
      before_action :doorkeeper_authorize!

      respond_to :json

      protected

      def current_resource_owner
        @current_resource_owner ||= User.find_by(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end

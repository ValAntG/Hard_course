module Api
  module V1
    class ProfilesController < BaseController
      def me
        respond_with current_resource_owner
      end
    end
  end
end

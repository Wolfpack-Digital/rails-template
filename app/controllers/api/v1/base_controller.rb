# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include ApiErrorHandling

      before_action :doorkeeper_authorize!

      protected

        def doorkeeper_unauthorized_render_options(error: nil)
          {
            json: {
              code: error.state,
              message: 'Not authorized',
              expired: error.reason == :expired
            }
          }
        end

        def render_error_message(message = nil)
          render json: {
            message: 'Error',
            errors: [message],
            code: 'unprocessable_entity'
          }, status: :unprocessable_entity
        end

        def current_user
          @current_user ||= User.find(doorkeeper_token[:resource_owner_id]) if doorkeeper_token.present?
        end

    end
  end
end

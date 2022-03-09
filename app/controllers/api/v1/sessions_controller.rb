# frozen_string_literal: true

module Api
  module V1
    class SessionsController < BaseController
      include Api::V1::SessionsControllerDoc

      skip_before_action :doorkeeper_authorize!, only: :create

      def create
        user = User.authenticate(user_sign_in_params[:email], user_sign_in_params[:password])

        return render_error_message(I18n.t('devise.failure.invalid', authentication_keys: :email)) unless user

        if user.active_for_authentication?
          render json: user, with_auth_tokens: true, status: :ok
        else
          render_error_message(I18n.t('devise.failure.unconfirmed'))
        end
      end

      def destroy
        doorkeeper_token.revoke

        head :ok
      end

      private

        def user_sign_in_params
          params.require(:user).permit(:email, :password)
        end
    end
  end
end

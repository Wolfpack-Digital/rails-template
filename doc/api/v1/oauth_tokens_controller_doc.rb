# frozen_string_literal: true

module Api
  module V1
    module OauthTokensControllerDoc
      extend Apipie::DSL::Concern

      api :POST, '/v1/sessions/token', 'Get new access and refresh tokens'
      param :grant_type,    ['refresh_token'], required: true, desc: 'Grant type of authorization flow'
      param :refresh_token, String,            required: true, desc: 'Valid refresh token'
      example <<-EXAMPLE
        // Default
        POST /api/v1/sessions/token
        {
          "grant_type": "refresh_token",
          "refresh_token": "VQU60dcUcuF3KxJCMaBg_HpDkvkESRDic0_oNL9EZaA"
        }
        200
        {
          "access_token": "o-XPPoiD53j-FtsRDqwZcXO6iGy_Zam-rH4gKsx526Y",
          "token_type": "Bearer",
          "expires_in": 3600,
          "refresh_token": "MjxNPmhEveeC_6EK_9tv3RuKTY418ojnf5bSdRXY1b0",
          "created_at": 1643790647
        }
      EXAMPLE
      def create_doc; end
    end
  end
end

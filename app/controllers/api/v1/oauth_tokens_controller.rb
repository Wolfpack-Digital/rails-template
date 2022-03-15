# frozen_string_literal: true

module Api
  module V1
    class OauthTokensController < Doorkeeper::TokensController
      include Api::V1::OauthTokensControllerDoc
    end
  end
end

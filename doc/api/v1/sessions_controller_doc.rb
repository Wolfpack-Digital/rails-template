# frozen_string_literal: true

module Api
  module V1
    module SessionsControllerDoc
      extend Apipie::DSL::Concern

      api :POST, '/v1/sessions', 'Sign in'
      param :user, Hash, required: true do
        param :email, String, required: true
        param :password, String, required: true
      end
      def create; end

      api :DELETE, '/v1/sessions', 'Sign out'
      param_group :authorization, ApipieDefinitions
      def destroy; end
    end
  end
end

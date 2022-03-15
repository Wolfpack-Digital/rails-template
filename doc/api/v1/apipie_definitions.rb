# frozen_string_literal: true

module Api
  module V1
    module ApipieDefinitions
      extend Apipie::DSL::Concern

      def_param_group :internal_error do
        error code: 500, desc: 'Internal server error'
      end

      def_param_group :not_found_error do
        error code: 404, desc: 'Resource not found'
      end

      def_param_group :client_errors do
        error code: 400, desc: 'Bad Request'
        error code: 422, desc: 'Unprocessable Entity'
      end

      def_param_group :authorization do
        header 'Bearer Token', 'Doorkeeper access token', required: true
        error code: 401, desc: 'Unauthorized'
      end
    end
  end
end

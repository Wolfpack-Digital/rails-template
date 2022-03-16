# frozen_string_literal: true

module ApiErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |exception|
      Bugsnag.notify(exception)

      render json: {
        message: "#{exception.model} with id=#{exception.id} not found",
        code: 'not_found'
      }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      Bugsnag.notify(exception)

      render json: {
        message: 'Validation Failed',
        **ValidationErrorsSerializer.new(exception.record).serialize
      }, status: :unprocessable_entity
    end

    rescue_from ActionController::ParameterMissing do |exception|
      Bugsnag.notify(exception)

      render json: {
        message: "Parameter missing: #{exception.param}",
        code: 'param_missing'
      }, status: :unprocessable_entity
    end

    rescue_from ActiveModel::UnknownAttributeError do |error|
      Bugsnag.notify(error)

      render json: {
        message: error.message,
        code: :unprocessable_entity
      }, status: :unprocessable_entity
    end
  end
end

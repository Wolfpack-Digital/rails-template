# frozen_string_literal: true

class ValidationErrorsSerializer
  attr_reader :record

  def initialize(record)
    @record = record
  end

  def serialize
    record.errors.details.map do |field, details|
      details.map do |error_details|
        {
          resource: record.class.to_s,
          field: field.to_s,
          code: error_details[:error].to_s
        }
      end
    end.flatten
  end
end

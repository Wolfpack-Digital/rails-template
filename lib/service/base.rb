# frozen_string_literal: true

module Service
  class Base
    def self.parameter(name)
      attr_reader name
      @parameters ||= []
      @parameters << name.to_sym
    end

    def self.optional_parameter(name)
      attr_reader name

      @optional_parameters ||= []
      @optional_parameters << name.to_sym
    end

    def self.parameters(*params)
      params.each do |param|
        parameter(param)
      end
    end

    def self.optional_parameters(*params)
      params.each do |param|
        optional_parameter(param)
      end
    end

    def self.call(**params)
      new(**params).tap(&:call)
    end

    def self.async_call(**params)
      queue = params.delete(:queue) || :default
      retry_count_arg = params.delete(:retry_count) || 0
      retry_error_arg = params.delete(:retry_error) || "StandardError"

      ServiceInvocationJob.perform_later(to_s, params, queue_name: queue, retry_count: retry_count_arg, retry_error: retry_error_arg)
    end

    def self.scheduled_call(time, **params)
      queue = params.delete(:queue) || :default
      retry_count_arg = params.delete(:retry_count) || 0
      retry_error_arg = params.delete(:retry_error) || "StandardError"

      ServiceInvocationJob.set(wait_until: time, queue:).perform_later(to_s, params, retry_count: retry_count_arg, retry_error: retry_error_arg)
    end

    def initialize(**params)
      defined_params = self.class.instance_variable_get('@parameters').presence || []

      set_parameters(params, defined_params)

      missing = defined_params - params.keys
      raise ArgumentError, "[#{self.class}] Missing params: #{missing.join(', ')}" unless missing.empty?

      call_init
    end

    def set_parameters(params, defined_params)
      optional_params = self.class.instance_variable_get("@optional_parameters").presence || []

      params.each do |param_name, param_value|
        raise ArgumentError, "[#{self.class}] Unexpected param: #{param_name}" unless param_name.in?(defined_params + optional_params)

        instance_variable_set("@#{param_name}", param_value)
      end
    end

    def call_init
      send(:init) if respond_to?(:init)
    end

    private_class_method :new
  end
end

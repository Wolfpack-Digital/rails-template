# frozen_string_literal: true

module Service
  class Base
    def self.parameter(name)
      attr_reader name
      @parameters ||= []
      @parameters << name.to_sym
    end

    def self.parameters(*params)
      params.each do |param|
        parameter(param)
      end
    end

    def self.call(**params)
      new(**params).tap(&:call)
    end

    def self.async_call(**params)
      ServiceInvocationWorker.perform_async(to_s, params)
    end

    def self.scheduled_call(time, **params)
      ServiceInvocationWorker.perform_in(time, to_s, params)
    end

    def initialize(**params)
      defined_params = self.class.instance_variable_get('@parameters').presence || []

      set_parameters(params, defined_params)

      missing = defined_params - params.keys
      raise ArgumentError, "[#{self.class}] Missing params: #{missing.join(', ')}" unless missing.empty?

      call_init
    end

    def set_parameters(params, defined_params)
      params.each do |param_name, param_value|
        raise ArgumentError, "[#{self.class}] Unexpected param: #{param_name}" unless param_name.in?(defined_params)

        instance_variable_set("@#{param_name}", param_value)
      end
    end

    def call_init
      send(:init) if respond_to?(:init)
    end

    private_class_method :new
  end
end

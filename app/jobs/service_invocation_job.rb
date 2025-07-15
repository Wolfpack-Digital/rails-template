class ServiceInvocationJob < ApplicationJob
  queue_as do
    arguments.find { |arg| arg.is_a?(Hash) && arg[:queue_name] }.try(:[], :queue_name) || :default
  end

  class << self
    def configure_retries(retry_count, retry_error)
      return unless retry_count.positive?

      error_class = retry_error&.safe_constantize || StandardError
      retry_on error_class, attempts: retry_count + 1
    end
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def perform(service_name, args, queue_name: :default, retry_count: 0, retry_error: nil)
    self.class.configure_retries(retry_count, retry_error)

    args.symbolize_keys!
    service_name.constantize.call(**args)
  end
  # rubocop:enable Lint/UnusedMethodArgument
end

# frozen_string_literal: true

class ServiceInvocationWorker
  include Sidekiq::Worker

  sidekiq_options retry: 0

  def perform(service_name, args)
    args.symbolize_keys!
    service_name.constantize.call(**args)
  end
end

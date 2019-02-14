# frozen_string_literal: true

class ServiceInvocationWorker
  include Sidekiq::Worker

  def perform(service_name, args)
    args.symbolize_keys!
    service_name.constantize.call(**args)
  end
end

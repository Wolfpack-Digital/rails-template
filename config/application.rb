insert_into_file 'config/application.rb', before: '# Require the gems listed in Gemfile, including any gems' do
  <<-'RUBY'
  require_relative '../lib/service/base.rb'
  RUBY
end

insert_into_file 'config/application.rb', before: /^  end/ do
  <<-'RUBY'

    # Use sidekiq to process Active Jobs (e.g. ActionMailer's deliver_later)
    config.active_job.queue_adapter = :sidekiq

    # Ensure non-standard paths are eager-loaded in production
    # (these paths are also autoloaded in development mode)
    # config.eager_load_paths += %W(#{config.root}/lib)
  RUBY
end

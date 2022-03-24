# base
insert_into_file 'example.env' do
  'SENDING_EMAIL=change@me.com'
end

# app
copy_file 'app/serializers/user_serializer.rb'
copy_file 'app/controllers/api/v1/sessions_controller.rb'
copy_file 'app/controllers/api/v1/oauth_tokens_controller.rb'
copy_file 'app/models/user.rb'

# config
copy_file 'config/initializers/devise.rb'
copy_file 'config/initializers/doorkeeper.rb'
copy_file 'config/locales/doorkeeper.en.yml'

insert_into_file 'config/application.rb', before: /^ end$/ do
  <<-'RUBY'

    config.to_prepare { Devise::Mailer.layout 'mailer' }
  RUBY
end

insert_into_file 'Gemfile', before: /^# Core$/ do
  <<-'GEMS'
# Auth
gem 'devise'
gem 'doorkeeper'

  GEMS
end

# docs
copy_file 'doc/api/v1/sessions_controller_doc.rb'
copy_file 'doc/api/v1/oauth_tokens_controller_doc.rb'

# specs
copy_file 'spec/requests/api/v1/sessions_controller_spec.rb'
copy_file 'spec/models/user_spec.rb'
copy_file 'spec/factories/oauth_access_tokens.rb'
copy_file 'spec/factories/users.rb'

# Database
now = Time.now.strftime('%Y%m%d%H%M%S').to_i
migration_folder = 'db/migrate/'

copy_file 'db/migrate/create_users.rb', "#{migration_folder}#{now}_create_users.rb"
copy_file 'db/migrate/add_devise_to_users.rb', "#{migration_folder}#{now + 1}_add_devise_to_users.rb"
copy_file 'db/migrate/add_doorkeeper_to_users.rb', "#{migration_folder}#{now + 2}_add_doorkeeper_to_users.rb"

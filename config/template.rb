apply 'config/application.rb'
template 'config/database.example.yml.tt'
remove_file 'config/database.yml'
copy_file 'config/puma.rb', force: true
copy_file 'config/sidekiq.yml'

gsub_file 'config/routes.rb', /  # root 'welcome#index'/ do
  '  root "home#index"'
end

copy_file 'config/initializers/generators.rb'
copy_file 'config/initializers/rotate_log.rb'
copy_file 'config/initializers/version.rb'
copy_file 'config/initializers/apipie.rb'
template 'config/initializers/sidekiq.rb.tt'

gsub_file 'config/initializers/filter_parameter_logging.rb', /\[:password\]/ do
  '%w[password secret session cookie csrf]'
end

apply 'config/environments/development.rb'
apply 'config/environments/production.rb'
apply 'config/environments/test.rb'
template 'config/environments/staging.rb.tt'

route 'root "home#index"'
route %(mount Sidekiq::Web => "/sidekiq" # monitoring console\n)
route 'apipie'
# CHECK IF THIS WORKING PROPERLY?
route %(
  namespace :api do
    namespace :v1 do
      resources :sessions, only: :create do
        delete '/', action: :destroy, on: :collection
      end
    end
  end)

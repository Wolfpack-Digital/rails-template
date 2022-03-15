apply 'config/application.rb'
template 'config/database.example.yml.tt'
remove_file 'config/database.yml'
copy_file "config/routes#{app_type}.rb", 'config/routes.rb', force: true
copy_file 'config/puma.rb', force: true
copy_file 'config/sidekiq.yml'

copy_file 'config/initializers/generators.rb'
copy_file 'config/initializers/rotate_log.rb'
copy_file 'config/initializers/version.rb'
copy_file 'config/initializers/apipie.rb'
gsub_file 'config/initializers/apipie.rb', /AppName/ do
  app_name.titleize
end
template 'config/initializers/sidekiq.rb.tt'

gsub_file 'config/initializers/filter_parameter_logging.rb', /\[:password\]/ do
  '%w[password secret session cookie csrf]'
end

apply 'config/environments/development.rb'
apply 'config/environments/production.rb'
apply 'config/environments/test.rb'
template 'config/environments/staging.rb.tt'

copy_file 'lib/service/base.rb'
copy_file 'app/workers/service_invocation_worker.rb'
copy_file 'app/controllers/api/v1/base_controller.rb'
copy_file 'app/controllers/concerns/api_error_handling.rb'
copy_file 'app/serializers/validation_errors_serializer.rb'
copy_file 'app/serializers/user_serializer.rb'
copy_file 'app/serializers/application_serializer.rb'
copy_file 'app/controllers/api/v1/sessions_controller.rb'
copy_file 'app/models/user.rb'

copy_file 'app/assets/stylesheets/application.scss'
remove_file 'app/assets/stylesheets/application.css'

copy_file 'app/views/layouts/application.html.erb', force: true
template 'app/views/layouts/base.html.erb.tt'

remove_dir 'app/jobs'
empty_directory_with_keep_file 'app/workers'

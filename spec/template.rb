copy_file 'spec/rails_helper.rb'
copy_file 'spec/spec_helper.rb'

copy_file 'spec/requests/api/v1/session_controller_spec.rb'
copy_file 'spec/models/user.rb'
copy_file 'spec/factories/oauth_access_tokens.rb'
copy_file 'spec/factories/users.rb'

empty_directory_with_keep_file 'spec/mailers'

apply 'spec/support/template.rb'

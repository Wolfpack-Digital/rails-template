copy_file 'spec/rails_helper.rb'
copy_file 'spec/spec_helper.rb'

empty_directory_with_keep_file 'spec/mailers'

apply 'spec/support/template.rb'

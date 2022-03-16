# frozen_string_literal: true

return unless Rails.env.development?

task :generate_erd do
  puts 'Generating erd diagrams...'
  create_doc_dir
  system "bundle exec rake erd #{full}"
  # you may want to create partial diagrams with specific models only for better visibility
  # system "bundle exec rake erd #{partial}"
end

Rake::Task['db:migrate'].enhance do
  Rake::Task['generate_erd'].invoke
end

Rake::Task['db:rollback'].enhance do
  Rake::Task['generate_erd'].invoke
end

def full
  "exclude='Doorkeeper::AccessToken' " \
    "filename='#{dir_name}/full' " \
    "title='Full ERD diagram' "
end

def partial
  "only='list your models here' " \
    "filename='#{dir_name}/partial' " \
    "title='Partial'"
end

def create_doc_dir
  return if Dir.exist?(dir_name)

  Dir.mkdir(dir_name)
end

def dir_name
  'doc/erd'
end

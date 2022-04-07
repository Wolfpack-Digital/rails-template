# frozen_string_literal: true

class ApiControllerGenerator < Rails::Generators::NamedBase
  desc 'This generator creates a controller, a documentation file and a spec file'

  class_option :version, type: :string, default: 'v1'
  class_option :methods, type: :string, default: ''

  def create_controller_file
    create_file "app/controllers/api/#{version}/#{file_name}_controller.rb", <<~FILE
      # frozen_string_literal: true

      module Api
        module V1
          class #{file_name.capitalize}Controller < BaseController
            #{'def index; end' if methods.match?('i')}
            #{'def show; end' if methods.match?('s')}
            #{'def create; end' if methods.match?('c')}
            #{'def update; end' if methods.match?('u')}
            #{'def destroy; end' if methods.match?('d')}
          end
        end
      end
    FILE
  end

  def create_doc_file
    create_file "doc/api/#{version}/#{file_name}_controller_doc.rb", <<~FILE
      # frozen_string_literal: true

      module Api
        module V1
          module #{file_name.capitalize}ControllerDoc
            extend Apipie::DSL::Concern

            #{if methods.match?('i')
                <<~RUBY
                  api :GET, "#{documentation_route.join('/')}", 'Get all resources'
                  def index; end
                RUBY
              end}

            #{if methods.match?('s')
                <<~RUBY
                  api :GET, "#{documentation_route.push(':id').join('/')}", 'Get one resources'
                  def show; end
                RUBY
              end}

            #{if methods.match?('c')
                <<~RUBY
                  api :POST, "#{documentation_route.join('/')}", 'Create a resource'
                  def create; end
                RUBY
              end}

            #{if methods.match?('u')
                <<~RUBY
                  api :PATCH, "#{documentation_route.push(':id').join('/')}", 'Update a resources'
                  def update; end
                RUBY
              end}

            #{if methods.match?('d')
                <<~RUBY
                  api :DELETE, "#{documentation_route.push(':id').join('/')}", 'Destroy a resource'
                  def destroy; end
                RUBY
              end}
          end
        end
      end
    FILE
  end

  def create_test_file
    create_file "spec/requests/api/#{version}/#{file_name}_controller_spec.rb", <<~FILE
      # frozen_string_literal: true

      require 'rails_helper'

      RSpec.describe Api::#{version.capitalize}::#{file_name.capitalize}Controller, type: :request do
      #{if methods.match?('i')
          <<~RUBY
            describe "GET #{route.join('/')}" do
            end
          RUBY
        end}

      #{if methods.match?('s')
          <<~RUBY
            describe "GET #{route.push(':id').join('/')}" do
            end
          RUBY
        end}

      #{if methods.match?('c')
          <<~RUBY
            describe "POST #{route.join('/')}" do
            end
          RUBY
        end}

      #{if methods.match?('u')
          <<~RUBY
            describe "PATCH #{route.push(':id').join('/')}" do
            end
          RUBY
        end}

      #{if methods.match?('d')
          <<~RUBY
            describe "DELETE #{route.push(':id').join('/')}" do
            end
          RUBY
        end}
      end#{' '}
    FILE
  end

  def format_files
    system("bundle exec rubocop -x **/#{file_name}_controller_*.rb")
  end

  private

  def methods
    options['methods']
  end

  def version
    options['version']
  end

  def route
    ['api', version, file_name]
  end

  def documentation_route
    route.drop(1)
  end
end

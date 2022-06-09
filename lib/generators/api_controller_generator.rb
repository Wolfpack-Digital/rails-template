# frozen_string_literal: true

# Creates controller, documentation and spec for new endpoints
class ApiControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :version, type: :string, default: 'v1'
  class_option :methods, type: :string, default: ''

  ACTIONS = {
    i: :index,
    c: :create,
    s: :show,
    d: :destroy,
    u: :update
  }.freeze

  def generate_api_controller
    @actions = methods.split('')
                      .map { |method| ACTIONS[method.to_sym] }
                      .reject(&:nil?)
    formatted_route_with_id

    template 'controller.rb.erb', "app/controllers/api/#{formatted_route}_controller.rb"
    template 'spec.rb.erb', "spec/requests/api/#{formatted_route}_request_spec.rb"
    template 'doc.rb.erb', "doc/api/#{formatted_route}_controller_doc.rb"
  end

  def final_steps
    system("rubocop -x --format simple **/#{name}_*.rb")
    puts "Don't forget to update the routes.rb!"
  end

  private

  def methods
    @methods ||= options['methods']
  end

  def version
    @version ||= options['version']
  end

  def route
    [version, class_path, file_name].flatten
  end

  def formatted_route
    @formatted_route ||= route.join('/')
  end

  def formatted_route_with_id
    @formatted_route_with_id ||= "#{formatted_route}/:id"
  end
end

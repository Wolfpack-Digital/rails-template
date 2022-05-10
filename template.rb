# frozen_string_literal: true

RAILS_REQUIREMENT = '~> 7.0.2'

def apply_template!
  assert_minimum_rails_version
  assert_valid_options
  assert_postgresql
  add_template_repository_to_source_path
  install_graphviz

  template 'Gemfile.tt', force: true
  template 'README.md.tt', force: true
  template 'example.env.tt'
  template 'ruby-version.tt', '.ruby-version', force: true

  remove_file 'README.rdoc'

  copy_file 'editorconfig', '.editorconfig'
  copy_file 'rspec', '.rspec'
  copy_file 'gitignore', '.gitignore', force: true
  copy_file 'overcommit.yml', '.overcommit.yml'
  copy_file 'simplecov', '.simplecov'
  copy_file '.erdconfig'
  copy_file 'Procfile'

  apply 'Rakefile.rb'
  apply 'app/template.rb'
  apply 'bin/template.rb'
  apply 'circleci/template.rb'
  apply 'config/template.rb'
  apply 'doc/template.rb'
  apply 'lib/template.rb'
  apply 'spec/template.rb'
  apply 'auth_template.rb' if include_auth_functionality

  remove_dir 'test'

  git :init unless preexisting_git_repo?
  empty_directory '.git/safe'

  run_with_clean_bundler_env 'bin/setup'
  generate_bundler_binstub

  binstubs = %w[
    annotate brakeman bundler bundler-audit rubocop sidekiq
  ]

  run_with_clean_bundler_env "bundle binstubs #{binstubs.join(' ')} --force"

  template 'rubocop.yml.tt', '.rubocop.yml'
  run_rubocop_autocorrections

  unless any_local_git_commits?
    git add: '-A .'
    git commit: "-n -m 'Set up project'"
    if git_repo_specified?
      git remote: "add origin #{git_repo_url.shellescape}"
      git push: '-u origin --all'
    end
  end
end

require 'fileutils'
require 'shellwords'

# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require 'tmpdir'
    source_paths.unshift(tempdir = Dir.mktmpdir('rails-template-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      '--quiet',
      'https://github.com/Wolfpack-Digital/rails-template.git',
      tempdir
    ].map(&:shellescape).join(' ')

    if (branch = __FILE__[%r{rails-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def assert_minimum_rails_version
  requirement = Gem::Requirement.new(RAILS_REQUIREMENT)
  rails_version = Gem::Version.new(Rails::VERSION::STRING)
  return if requirement.satisfied_by?(rails_version)

  prompt = "This template requires Rails #{RAILS_REQUIREMENT}. "\
           "You are using #{rails_version}. Continue anyway?"
  exit 1 if no?(prompt)
end

# Bail out if user has passed in contradictory generator options.
def assert_valid_options
  valid_options = {
    skip_gemfile: false,
    skip_bundle: false,
    skip_git: false,
    edge: false
  }
  valid_options.each do |key, expected|
    next unless options.key?(key)

    actual = options[key]
    raise Rails::Generators::Error, "Unsupported option: #{key}=#{actual}" unless actual == expected
  end
end

def assert_postgresql
  return if IO.read('Gemfile') =~ /^\s*gem ['"]pg['"]/

  raise Rails::Generators::Error,
        'This template requires PostgreSQL, '\
        'but the pg gem isn’t present in your Gemfile.'
end

def git_repo_url
  @git_repo_url ||=
    ask_with_default('What is the git remote URL for this project?', :blue, 'skip')
end

def production_hostname
  @production_hostname ||=
    ask_with_default('Production hostname?', :blue, 'example.com')
end

def staging_hostname
  @staging_hostname ||=
    ask_with_default('Staging hostname?', :blue, 'staging.example.com')
end

def include_auth_functionality
  return @include_auth_functionality if defined?(@include_auth_functionality)

  @include_auth_functionality =
    %w[yes y].include?(ask_with_default('Include user authentiaction? Y/n', :red, 'Y').downcase)
end

def app_type
  include_auth_functionality ? '_with_auth' : ''
end

def gemfile_requirement(name)
  @original_gemfile ||= IO.read('Gemfile')
  req = @original_gemfile[/gem\s+['"]#{name}['"]\s*(,?[><~= \t\d.\w'"]*)?.*$/, 1]
  req && req.tr("'", %(")).strip.sub(/^,\s*"/, ', "')
end

def ask_with_default(question, color, default)
  return default unless $stdin.tty?

  question = (question.split('?') << " [#{default}]?").join
  answer = ask(question, color)
  answer.to_s.strip.empty? ? default : answer
end

def git_repo_specified?
  git_repo_url != 'skip' && !git_repo_url.strip.empty?
end

def preexisting_git_repo?
  @preexisting_git_repo ||= (File.exist?('.git') || :nope)
  @preexisting_git_repo == true
end

def any_local_git_commits?
  system('git log &> /dev/null')
end

def run_with_clean_bundler_env(cmd)
  success = if defined?(Bundler)
              Bundler.with_clean_env { run(cmd) }
            else
              run(cmd)
            end
  return if success

  puts "Command failed, exiting: #{cmd}"
  exit(1)
end

def run_rubocop_autocorrections
  run_with_clean_bundler_env 'bin/rubocop -A --fail-level A > /dev/null || true'
end

def app_name
  @app_name ||= @app_path.gsub(/_-/, ' ').titleize
end

def install_graphviz
  if brew_installed?
    run_with_clean_bundler_env('brew install graphviz')
  elsif apt_installed?
    run_with_clean_bundler_env('sudo apt install graphviz')
  elsif yum_installed?
    run_with_clean_bundler_env('sudo yum install graphviz')
  end
end

def brew_installed?
  system('which brew')
end

def apt_installed?
  system('which apt')
end

def yum_installed?
  system('which yum')
end

apply_template!

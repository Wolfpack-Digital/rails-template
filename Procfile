web:     bundle exec puma -C config/puma.rb
worker:  bin/rails solid_queue:start
release: bundle exec rails db:migrate db:seed

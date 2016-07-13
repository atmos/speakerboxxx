web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: /usr/bin/env LIBRATO_AUTORUN=1 bundle exec sidekiq
release: rake db:migrate

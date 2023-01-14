#!/bin/sh

set -e

sleep 2

echo "Environment: $RAILS_ENV"

# install missing gems
bundle check || bundle install --jobs 20 --retry 5

# Remove pre-existing puma/passenger server.pid
if [ -f tmp/pids/server.pid ]; then
  rm -f tmp/pids/server.pid
fi

echo "Environment: $RAILS_ENV"
if [ $RAILS_ENV != 'test' ]; then
  if [ "$( PGPASSWORD=$DATABASE_PASSWORD psql -U $DATABASE_USERNAME -h $DATABASE_HOST -c"SELECT 1 FROM pg_database WHERE datname='$DATABASE_NAME'" )" = '1' ]
  then
      echo "Database already exists"
  else
      echo "Database does not exist"

      echo "bundle exec rake db:create db:migrate"
      RAILS_ENV=$RAILS_ENV bundle exec rake db:create db:migrate
  fi
fi

if [ $RAILS_ENV == 'test' ]; then
  if [ "$( PGPASSWORD=$DATABASE_PASSWORD psql -U $DATABASE_USERNAME -h $DATABASE_HOST -c"SELECT 1 FROM pg_database WHERE datname='$DATABASE_NAME'" )" = '1' ]
  then
      echo "Database already exists"
  else
      echo "Database does not exist"

      echo "bundle exec rake db:test:prepare"
      bundle exec rake db:test:prepare
  fi
fi

# run passed commands
bundle exec ${@}

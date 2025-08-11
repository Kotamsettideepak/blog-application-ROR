#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Check if database exists
if bundle exec rake db:version; then
  echo "Running migrations..."
  bundle exec rake db:migrate
else
  echo "Setting up database..."
  bundle exec rake db:setup
fi

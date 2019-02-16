#!/usr/bin/env bash

docker-compose build
docker-compose run api bin/rake db:create
docker-compose run api bin/rake db:migrate
docker-compose run api bundle exec annotate
docker-compose run api rails g rspec:install
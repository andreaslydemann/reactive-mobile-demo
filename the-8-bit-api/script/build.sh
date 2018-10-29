#!/usr/bin/env bash

docker-compose build
docker-compose run the-8-bit-api bin/rake db:create && bin/rake db:migrate

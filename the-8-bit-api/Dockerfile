FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /the-8-bit-api
WORKDIR /the-8-bit-api
COPY Gemfile /the-8-bit-api/Gemfile
COPY Gemfile.lock /the-8-bit-api/Gemfile.lock
RUN bundle install
COPY . /the-8-bit-api
FROM ruby:2.5.1

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /chat_test
WORKDIR	 /chat_test

ADD Gemfile /chat_test/Gemfile
ADD Gemfile.lock /chat_test/Gemfile.lock

RUN bundle install

ADD . /chat_test
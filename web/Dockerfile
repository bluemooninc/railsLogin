FROM ruby:2.5.0

RUN apt-get update && apt-get install -y build-essential libpq-dev postgresql-client
RUN gem install rails
RUN curl -SL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install -y nodejs
RUN mkdir /app
WORKDIR /app

ENV YARN_VERSION 1.13.0

# install yarn
RUN curl -L --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" > /tmp/yarn.tar.gz && \
  tar -xzf /tmp/yarn.tar.gz -C /opt && \
  ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn && \
  ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg && \
  rm /tmp/yarn.tar.gz

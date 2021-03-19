FROM ruby:2.6.6-buster

ENV BUNDLE_JOBS=4 \
    BUNDLE_RETRY=5

WORKDIR /app

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && apt-get install --no-install-recommends -y \
    postgresql-client-12 \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock conflict_free_schema.gemspec ./

ENV BUNDLE_VERSION=2.0.2

RUN gem update --system && gem install bundler:$BUNDLE_VERSION
RUN bundle install

COPY Appraisals ./
RUN bundle exec appraisal install
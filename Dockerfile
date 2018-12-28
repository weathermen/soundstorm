#
# Docker image build script for Soundstorm
#

# Use latest Ruby
FROM ruby:2.5.3

# Install system dependencies
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y build-essential libpq-dev nodejs yarn libsndfile1-dev ffmpeg

# Define build arguments and their defaults
ARG RAILS_ENV

# Set up environment
ENV BUNDLE_PATH=/gems \
    BUNDLE_BIN=/gems/bin \
    BUNDLE_JOBS=8 \
    APP_PATH=/srv \
    RAILS_ENV=$RAILS_ENV \
    PUMA_PIDFILE_PATH=/tmp/pids \
    ACME_AGREE=true \
    PATH=/usr/local/bundle/bin:/srv/bin:/gems/bin:$PATH

# Copy in application code
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH
COPY . $APP_PATH

# Install application dependencies and precompile assets in production.
RUN ./bin/build

# Precompile assets in production, install dependencies in development
ENTRYPOINT ["sh", "bash ./bin/entrypoint.sh"]

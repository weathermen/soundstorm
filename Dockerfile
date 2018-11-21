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
    && apt-get install -y build-essential libpq-dev nodejs yarn

# Set up environment
ENV BUNDLE_PATH=/gems \
    GEM_HOME=/gems \
    BUNDLE_BIN=/gems/bin \
    APP_PATH=/srv \
    PATH=/usr/local/bundle/bin:$APP_PATH/bin:$BUNDLE_BIN:$PATH

# Copy in application code
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH
COPY . $APP_PATH

# Install application dependencies before proceeding
ENTRYPOINT ["sh", "bin/entrypoint.sh"]

# Use latest Ruby
FROM ruby:2.5.1

# Install system dependencies
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y build-essential libpq-dev nodejs yarn

# Use Bundler cache
ENV BUNDLE_PATH=/gems \
    GEM_HOME=/gems \
    BUNDLE_BIN=/gems/bin \
    PATH=/usr/local/bundle/bin:/srv/bin:$BUNDLE_BIN:$PATH

# Update application code
RUN mkdir -p /srv
WORKDIR /srv
COPY . /srv

# Configure entrypoint to install application dependencies
ENTRYPOINT ["sh", "bin/entrypoint.sh"]

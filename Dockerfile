# Use latest Ruby
FROM ruby:2.5.1

# Install PostgreSQL and NodeJS
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Install Yarn package manager
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
ENV PATH $HOME/.yarn/bin:$PATH

# Use Bundler cache
ENV BUNDLE_PATH=/gems GEM_HOME=/gems BUNDLE_BIN=/gems/bin

# Update application code
RUN mkdir -p /srv
WORKDIR /srv
COPY . /srv

# Configure entrypoint to install application dependencies
ENTRYPOINT ["sh", "bin/entrypoint.sh"]

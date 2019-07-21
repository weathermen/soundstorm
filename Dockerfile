#
# Docker image build script for Soundstorm
#

# Use latest Ruby
FROM ruby:2.6.5-alpine

# Install system dependencies
RUN apk update
RUN apk add --no-cache --update build-base \
                                curl \
                                linux-headers \
                                ffmpeg \
                                git \
                                nodejs \
                                yarn \
                                tzdata \
                                postgresql-dev \
                                libsndfile-dev \
                                imagemagick \
                                yajl

# Create working directory
ENV APP_PATH=/usr/src/app
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

# Add application dependency manifests
COPY Gemfile $APP_PATH/Gemfile
COPY Gemfile.lock $APP_PATH/Gemfile.lock
COPY package.json $APP_PATH/package.json
COPY yarn.lock $APP_PATH/yarn.lock

# Install Ruby dependencies
RUN gem update bundler
RUN bundle install --jobs `expr $(cat /proc/cpuinfo | grep -c "cpu cores") - 1` --retry 3

# Define build environment
ARG RAILS_ENV=development
ARG SECRET_KEY_BASE
ENV NODE_ENV=$RAILS_ENV \
    RAILS_LOG_TO_STDOUT=true

# Install JavaScript dependencies
RUN yarn install --check-files

# Copy in application source code
COPY . $APP_PATH

# Precompile assets in production
RUN if [ "$RAILS_ENV" = "production" ] ; then rails assets:precompile; fi

# Install entrypoint script
COPY bin/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Set up container defaults
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
HEALTHCHECK CMD curl --fail "http://localhost:3000/health" || exit 1

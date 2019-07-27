#
# Reference script for creating a new Heroku app
#

HEROKU_APP=$1

heroku create $HEROKU_APP

heroku addons:create heroku-redis:hobby-dev -a $HEROKU_APP
heroku addons:create heroku-postgresql:hobby-dev -a $HEROKU_APP
heroku addons:create bonsai:sandbox-6 -a $HEROKU_APP
heroku addons:create sendgrid:starter -a $HEROKU_APP
heroku addons:create expeditedssl:single-cert -a $HEROKU_APP

heroku config:set -a $HEROKU_APP \
  RAILS_ENV=production \
  NODE_ENV=production \
  RAILS_SERVE_STATIC_FILES=true \
  RAILS_LOG_TO_STDOUT=true \
  AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  AWS_REGION=$AWS_REGION \
  AWS_S3_BUCKET_NAME=$HEROKU_APP \
  ELASTICSEARCH_URL=$(heroku config:get -a $HEROKU_APP BONSAI_URL)

make provision

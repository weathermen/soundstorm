# Run all tests with CodeClimate test reporting
export GIT_BRANCH="${GITHUB_REF##*/}"
export GIT_COMMIT_SHA="$GITHUB_SHA"

bin/cc-test-reporter before-build &&
  bin/rails test test/**/*_test.rb &&
  bin/cc-test-reporter format-coverage &&
  bin/cc-test-reporter sum-coverage coverage/codeclimate.json &&
  bin/cc-test-reporter upload-coverage

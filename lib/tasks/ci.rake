# frozen_string_literal: true

namespace :ci do
  TRAVIS_TEST_RESULT = ENV.fetch('TRAVIS_TEST_RESULT', '0')

  desc 'Set up CodeClimate test coverage reporter in CI'
  task :setup do
    sh 'curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter'
    sh 'chmod +x ./cc-test-reporter'
    sh './cc-test-reporter before-build'
  end

  desc 'Report test coverage to CodeClimate'
  task :report do
    sh "./cc-test-reporter after-build --exit-code #{TRAVIS_TEST_RESULT}"
  end
end

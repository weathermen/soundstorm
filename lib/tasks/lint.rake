require 'rubocop/rake_task'

namespace :lint do
  RuboCop::RakeTask.new :ruby

  desc 'Run ESLint JavaScript lint checks'
  task :js do
    sh 'yarn exec eslint app/javascript'
  end

  desc 'Run Stylelint CSS lint checks'
  task :css do
    sh 'yarn exec stylelint app/assets/stylesheets'
  end
end

task lint: %i[lint:ruby lint:js lint:css]

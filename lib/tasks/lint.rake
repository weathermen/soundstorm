require 'rubocop/rake_task'
require 'haml_lint/rake_task'

HamlLint::RakeTask.new

namespace :lint do
  RuboCop::RakeTask.new :ruby
  HamlLint::RakeTask.new :haml

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

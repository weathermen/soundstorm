desc 'Create the database and remove the log and tmp directories'
task setup: %i[db:setup log:clear tmp:clear]

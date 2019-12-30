desc 'Set up credentials, then install the database and search index'
task install: %i[credentials:edit db:setup elasticsearch]

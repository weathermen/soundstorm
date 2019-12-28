desc 'Set up the database and search index, then edit credentials'
task install: %i[credentials:edit db:setup elasticsearch]

namespace :db do
  desc 'If the database does not exist, set it up. Otherwise, migrate it'
  task update: :environment do
    name = "soundstorm_#{Rails.env}"
    database_exists = ApplicationRecord.connection.execute(%(
      select exists(
        select datname
          from pg_catalog.pg_database
          where lower(datname) = lower('#{name}')
      );
    ))

    if database_exists
      puts "Migrating database '#{name}'..."
      Rake::Task['db:migrate'].invoke
    else
      puts "Creating database '#{name}'..."
      Rake::Task['db:setup'].invoke
    end
  end
end

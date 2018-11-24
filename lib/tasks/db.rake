namespace :db do
  desc 'If the database does not exist, set it up. Otherwise, migrate it'
  task update: :environment do
    database_exists = ApplicationRecord.connection.execute(%(
      select exists(
        select datname
          from pg_catalog.pg_database
          where lower(datname) = lower('soundstorm_#{Rails.env}')
      );
    ))

    if database_exists
      puts "Creating database..."
      Rails::Task['db:setup'].invoke
    else
      puts "Migrating database..."
      Rails::Task['db:migrate'].invoke
    end
  end
end

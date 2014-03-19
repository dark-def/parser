namespace :db do
  task :environment do
    require 'active_record'
    ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database =>  'db/time_daily.sqlite3'
  end

  desc 'Migrate the database'
  task(:migrate => :environment) do
    require 'logger'
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    ActiveRecord::Migration.verbose = true
    puts 'run migration'
    ActiveRecord::Migrator.migrate('db/migrate')
  end

  desc 'cleaning tables'
  task(:clean => :environment) do
    require 'logger'
    conn = ActiveRecord::Base.connection
    tables = conn.execute("SELECT name FROM sqlite_master where type = 'table'").map { |r| r[0] }
    tables.delete "schema_migrations"
    tables.delete "sqlite_sequence"
    tables.each { |t| conn.execute("Delete From #{t}") }
  end

  desc 'drop tables'
  task(:drop => :environment) do
    require 'logger'
    conn = ActiveRecord::Base.connection
    tables = conn.execute("SELECT name FROM sqlite_master where type = 'table'").map { |r| r[0] }
    tables.delete "sqlite_sequence"
    tables.map{|table| puts "drop #{table}"; ActiveRecord::Migration.drop_table(table)}
  end
end

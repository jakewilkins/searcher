

desc 'run the shits'
task :run => :'runner:env' do
  Runner.run
end

desc 'look the shits'
task :poll do
  require_relative 'poller'
  Poller.go
end

task :console => :'runner:env' do
  require 'pry'
  binding.pry
end

namespace :runner do
  task :env do
    require_relative 'setup'
    Setup.rake
  end
end

namespace :crags do
  task :req do
    require 'crags'
  end

  task :cache => :req do
    Crags::Category.all
    Crags::Category.cache
  end

  task :clear_cache => :req do
    Crags::Category.clear_cache
  end

  task :refresh_categories => [:clear_cache, :load_cache]
end

namespace :db do
  desc 'run migrations'
  task :migrate, [:version] do |t, args|
    require "sequel"
    Sequel.extension :migration

    db = Sequel.connect(ENV.fetch("DATABASE_URL"))

    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end

  desc 'rollback migrations'
  task :down do |t, args|
    require "sequel"
    Sequel.extension :migration

    db = Sequel.connect(ENV.fetch("DATABASE_URL"))

    #if args[:version]
      #puts "Migrating to version #{args[:version]}"
      #Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    #else
      puts "Migrating to 0"
      Sequel::Migrator.run(db, "db/migrations", target: 0)
    #end
  end
end


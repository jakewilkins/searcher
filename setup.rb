module Setup
  def self.wait_for_db
    loop do
      begin
        print "attempting to connect..."
        Module.const_set(:DB, Sequel.connect(ENV.fetch('DATABASE_URL')))
        puts " success!"
        break
      rescue
        puts " failed, waiting and retrying."
        sleep 10
        retry
      end
    end
  end

  def self.wait_for_tables
    loop do
      begin
        print "looking for models..."
        Result.first
        puts " success!"
        break
      rescue
        Rake::Task[:'db:migrate'].invoke
      end
    end
  end

  def self.poller
    require 'bundler/setup'

    require 'pry' if ENV['DEBUG']

    require 'sequel'
    set_db_url_env
    yield if block_given?
    #Module.const_set(:DB, Sequel.connect(ENV.fetch('DATABASE_URL')))
    #DB = Sequel.connect(ENV.fetch('DATABASE_URL'))

    File.write("/var/run/craigslist.pid", Process.pid) rescue nil

    require_relative 'models/notification'
    require_relative 'models/result'
    require_relative 'models/search'
    require_relative 'models/subscriber'

    require 'crags'

    Crags::Config.defaults[:location] = Crags::Location.new('losangeles.craigslist.org')
    Crags::Config.defaults[:category_ur] = "http://losangeles.craigslist.org/"
    Crags::Config.category_url = "http://losangeles.craigslist.org/"

    require_relative 'search_executor'
    require_relative 'search_updater'
    require_relative 'result_notifier'
    require_relative 'runner'
  end

  def self.rake
    require 'bundler/setup'

    require 'pry' if ENV['DEBUG']

    require 'sequel'
    set_db_url_env
    Module.const_set(:DB, Sequel.connect(ENV.fetch('DATABASE_URL')))
    #DB = Sequel.connect(ENV.fetch('DATABASE_URL'))

    require_relative 'models/notification'
    require_relative 'models/result'
    require_relative 'models/search'
    require_relative 'models/subscriber'

    require 'crags'

    Crags::Config.defaults[:location] = Crags::Location.new('losangeles.craigslist.org')
    Crags::Config.defaults[:category_ur] = "http://losangeles.craigslist.org/"
    Crags::Config.category_url = "http://losangeles.craigslist.org/"

    require_relative 'search_executor'
    require_relative 'search_updater'
    require_relative 'result_notifier'
    require_relative 'runner'
  end

  def self.set_db_url_env
    ENV['DATABASE_URL'] ||= begin
      "postgres://#{postgres_env("POSTGRES_USER")}:"\
        "#{postgres_env("POSTGRES_PASSWORD")}@postgres."\
        "fulcrum/#{postgres_env("POSTGRES_DB")}"
    end
  end

end

require_relative 'setup'
require_relative 'procline'
require 'logger'

class Poller
  attr_reader :procline, :logger

  def self.go
    new.go
  end

  def initialize
    @procline = Procline.new
    @logger = Logger.new("poller.log")
    logger.level = Logger::WARN
  end

  def go
    Setup.poller do
      Setup.wait_for_db
      require_relative 'models/result'
      Setup.wait_for_tables
    end

    @quit = false
    trap('INT') { @quit = true}
    two_hours = 120 * 60
    tick = 0

    run # run on start
    loop do
      break if @quit
      if tick > two_hours
        tick = 0
        run
      else
        tick += 1
        procline.tick(tick)
        sleep 1
      end
    end
    logger.fatal "byeeeeeeee!!!"
  end

  def run
    begin
      logger.debug 'beginning search poll...'
      procline.begin_run
      Runner.run
      procline.complete_run
      logger.info " search executed successfully, sleeping for two hours!"
    rescue Exception => boom
      procline.error_run
      logger.error "got a #{boom.message}:\n#{boom.backtrace.join("\n")}"
    end
  end
end

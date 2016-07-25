require_relative 'setup'
require_relative 'procline'

class Poller
  attr_reader :procline

  def self.go
    new.go
  end

  def initialize
    @procline = Procline.new
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
    puts "byeeeeeeee!!!"
  end

  def run
    begin
      print 'beginning search poll...'
      procline.begin_run
      Runner.run
      procline.complete_run
      puts " search executed successfully, sleeping for two hours!"
    rescue Exception => boom
      procline.error_run
      puts "got a #{boom.message}:\n#{boom.backtrace.join("\n")}"
    end
  end
end

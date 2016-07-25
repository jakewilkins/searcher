
class Runner
  class SubscriberUpdates
    attr_reader :data
    def initialize
      @data = {}
    end

    def send(s, search, result)
      data[s] ||= {}
      data[s][search] ||= []
      data[s][search] << result
    end

    def each(&block)
      data.each(&block)
    end
  end

  def self.run
    new.exec
  end

  attr_reader :updates

  def initialize
    @updates = SubscriberUpdates.new
  end

  def exec
    Search.all {|search| SearchUpdater.call(search, updates)}
    ResultNotifier.call(updates)
  end
end

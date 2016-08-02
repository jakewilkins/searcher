
class Runner

  def self.run
    Search.all {|search| SearchUpdater.call(search, SubscriberUpdates)}
    ResultNotifier.call(SubscriberUpdates)
  end

end

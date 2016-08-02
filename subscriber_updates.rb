
module SubscriberUpdates
  module_function

  def send(person, search, result)
    notif = build_notification_if_needed(person, search)
    NotificationResult.new(notification_id: notif.id, result_id: result.id).tap {|nr|
      nr.save
    }
  end

  def each(&block)
    Notification.where(notified: false).each do |notification|
      person = notification.person
      next if person.do_not_disturb?

      yield EmailResultSet.new(person, notification)
    end
  end

  class EmailResultSet
    attr_reader :person, :notification, :searches
    def initialize(person, notification)
      @person, @notification = person, notification
      @searches = load_searches
    end

    def search_names
      searches.map {|s| s.name}.join(", ")
    end

    def result_count
      notification.results.count
    end

    def each(&block)
      searches.each do |search|
        results = notification.results_dataset.where(search_id: search.id).to_a
        yield search, results
      end
    end

    # TODO: there's a DB optimization here where we just collect ID's and
    # issue a single UPDATE at the end. there are probably a lot of those
    # hanging around...
    def notified!
      notification.notified = true
      notification.save
    end

    private

    # yoinks
    def load_searches
      #search_ids = NotificationResult.distinct.where(notification_id: notification.id).join(:results, id: :result_id).select(:'result.search_id')
      #search_ids.map {|id| Search[search_id]}
      notification.results.map {|n| n.search}.uniq
    end
  end

  def build_notification_if_needed(person, search)
    notif = Notification.where(person_id: person.id, notified: false).first
    return notif if notif

    build_notification(person, search)
  end

  def build_notification(person, search)
    Notification.new(person_id: person.id, notified: false).tap {|n| n.save }
  end
end


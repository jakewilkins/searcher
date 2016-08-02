class NotificationResult < Sequel::Model(:notifications_results)
  #self.table_name "notifications_results"

  #one_to_one :notification, key: :notification_id
  one_to_one :notification, key: :notification_id, primary_key: :id
  one_to_one :result, primary_key: :id
end


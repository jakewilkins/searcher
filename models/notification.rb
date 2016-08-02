class Notification < Sequel::Model
  many_to_many :results, join_table: :notifications_results,
    right_key: :result_id
  many_to_one :person
end

class Notification < Sequel::Model
  one_to_many :results
  one_to_one :subscriber
end

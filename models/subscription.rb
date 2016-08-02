
class Subscription < Sequel::Model
  many_to_one :search
  many_to_one :person
end


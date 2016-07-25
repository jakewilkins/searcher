
class Subscriber < Sequel::Model
  many_to_one :search
end

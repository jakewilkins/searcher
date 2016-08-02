require 'json'
class Search < Sequel::Model
  one_to_many :results
  many_to_many :people, join_table: :subscriptions

  attr_accessor :url

  def opts
    @opts ||= JSON.load(params)
  end

  def set_opts(hsh)
    self.params(JSON.dump(hsh))
  end
end

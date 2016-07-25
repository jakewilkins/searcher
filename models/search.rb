require 'json'
class Search < Sequel::Model
  one_to_many :results
  one_to_many :subscribers

  attr_accessor :url

  def opts
    @opts ||= JSON.load(params)
  end

  def set_opts(hsh)
    self.params(JSON.dump(hsh))
  end
end

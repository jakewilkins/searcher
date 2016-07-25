class SearchUpdater
  def self.call(search, updates)
    new(search, updates).call
  end

  attr_reader :search, :updates

  def initialize(search, updates)
    @search, @updates = search, updates
  end

  def call
    SearchExecutor.new(search).each { |cres|
      unless Result.find(url: cres.url)
        r = Result.from_crag(cres)
        r.search = search
        r.save

        search.subscribers.each do |s|
          updates.send(s, search, r)
        end
      end
    }
  end

end

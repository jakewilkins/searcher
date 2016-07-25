class SearchExecutor
  attr_reader :search
  def initialize(search)
    @search = search
  end

  def each(&block)
    search.url = crags.url
    crags.each(&block)
  end

  private

  def crags
    @crags ||= if @search.search_url
      Crags::Search::Location.new(url: @search.search_url)
    else
      cat = Crags::Category[search.opts['category']]
      Crags::Search::Location.new(category: cat, location: location).tap { |cr|
        apply_search_opts(cr)
      }
    end
    @crags
  end

  def apply_search_opts(crags)
    search.opts.each do |name, val|
      next if name == 'category'
      send(:"apply_#{name}", crags, val)
    end
  end

  def apply_auto_make_model(c, val)
    c.auto_make_model = val
  end

  def apply_price_range(c, val)
    c.price_range(min: val['min'], max: val['max'])
  end

  def apply_distance(c, val)
    c.distance(*val)
  end

  def apply_odometer(c, val)
    c.odometer(min: val['min'], max: val['max'])
  end

  def apply_auto_year(c, val)
    c.auto_year(min: val['min'], max: val['max'])
  end

  def location
    Crags::Config.defaults[:location]
  end
end

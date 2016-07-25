module Crags
  module Search
    class Location < Search
      include ERB::Util
      include Enumerable
      include Fetcher
      extend AttrChain
      chained_attr_accessor :location

      attr_reader :area, :price_range, :auto_year, :odometer, :auto_make_model
      attr_writer :auto_make_model

      Area = Struct.new(:zip, :dist)
      Range = Struct.new(:min, :max)

      def initialize(opts = {})
        super(opts)
        @location = @opts[:location]
        @preset_url = @opts[:url] if @opts[:url]
      end

      def distance(zip, dist = 5)
        @area = Area.new(zip, dist)
      end

      def price_range(min: nil, max:nil)
        @price_range = Range.new(min, max)
      end

      def auto_year(min: nil, max: nil)
        @auto_year = Range.new(min, max)
      end

      def odometer(min: nil, max: nil)
        @odometer = Range.new(min, max)
      end

      def url
        return @preset_url if @preset_url
        u = URI(location.url)
        u.path = category.url
        u.query = "#{keyword_part}#{auto_make_part}#{area_part}#{price_range_part}#{year_range}#{odometer_range}"
        u.to_s
      end

      def doc
        fetch_doc(url)
      end

      def items
        doc.search("#sortable-results p.row").collect do |elem|
          Item.listing(self, elem)
        end
      end

      def each
        return items.each unless block_given?
        items.each { |item| yield item }
      end

      private

      def keyword_part
        if keyword
          "query=#{keyword}"
        end
      end

      def auto_make_part
        if auto_make_model
          "&auto_make_model=#{auto_make_model}"
        end
      end

      def area_part
        if area
          "&search_distance=#{area.dist}&postal=#{area.zip}"
        end
      end

      def price_range_part
        str = ""
        if price_range
          str += "&min_price=#{price_range.min}" unless price_range.min.nil?
          str += "&max_price=#{price_range.max}" unless price_range.max.nil?
        end
        str
      end

      def year_range
        str = ""
        if auto_year
          str += "&min_auto_year=#{auto_year.min}" unless auto_year.min.nil?
          str += "&max_auto_year=#{auto_year.max}" unless auto_year.max.nil?
        end
        str
      end

      def odometer_range
        str = ""
        if odometer
          str += "&min_auto_miles=#{odometer.min}" unless odometer.min.nil?
          str += "&max_auto_miles=#{odometer.max}" unless odometer.max.nil?
        end
        str
      end
    end
  end
end

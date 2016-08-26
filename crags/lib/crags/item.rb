require 'forwardable'
require 'crags/item/listing'
require 'crags/item/full'

module Crags
  class Item
    extend Forwardable

    class << self
      def listing(search, elem)
        new(search).tap {|i| i.listing = Listing.from_elem(i, elem)}
      end
    end

    attr_reader :listing, :search
    attr_writer :listing, :full

    def_delegators :listing, :url, :title, :images, :price, :date, :location, :post_id, :repost_of
    def_delegators :full, :body

    def initialize(search, listing: nil)
      @search = search
      @listing = listing
    end

    def url_for(path = '/')
      if path[0..1] == "//" || %w|http https|.include?(path.split(':').first)
        URI(path).tap {|u| u.scheme = "https"}.to_s
      else
        URI(search.location.url).tap {|u| u.path = path}.to_s
      end
    end

    def full
      @full ||= Full.for_listing(self, listing)
    end

  end
end

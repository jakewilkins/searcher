require 'crags/item/image'

module Crags
  class Item
    class Listing
      class << self
        def from_elem(item, elem)
          new(item, title: elem_title(elem),
              path: elem_path(elem),
              date: elem_date(elem),
              images: elem_images(elem),
              price: elem_price(elem),
              location: elem_location(elem),
              post_id: elem['data-pid'],
              repost_of: elem['data-repost-of'])
        end

        private

        def elem_title(e)
          e.search('span#titletextonly').first&.text
        end

        def elem_path(e)
          e.search('a:has(span)').first['href']
        end

        def elem_date(e)
          e.search('time').first['datetime']
        end

        def elem_price(e)
          e.search('span.price').first&.text
        end

        def elem_location(e)
          e.search('span.pnr small').first&.text
        end

        def elem_images(e)
          return [] if e.search('a.i.gallery').first['data-ids'].nil?
          Image.for_data_ids(e.search('a.i.gallery').first['data-ids'])
        end
      end

      attr_reader :item, :title, :path, :date, :images, :price, :location, :post_id, :repost_of

      def initialize(item, title:, path:, date:, images:, price:, location:, post_id:, repost_of:)
        @item, @title, @path, @date, @images = item, title, path, date, images
        @price, @location, @post_id, @repost_of = price, location, post_id, repost_of
      end

      def url
        item.url_for(path)
      end

      def is_repost?
        !!@repost_of
      end
    end
  end
end

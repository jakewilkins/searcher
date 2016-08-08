module Crags
  class Item
    class Full
      extend Fetcher

      class << self
        def for_listing(item, listing)
          for_page(item, fetch_doc(listing.url))
        end

        def for_page(item, page)
          new(item, title: page_title(page),
              date: page_date(page),
              url: page_url(page),
              body: page_body(page),
              attrs: page_attrs(page),
              map: page_map(page),
              reply_path: page_reply_path(page))
        end

        private

        def page_title(page)
          page.search('head title').first.text
        end

        def page_date(page)
          dt = page.search('p#display-date time').first
          return '' unless dt
          dt['datetime']
        end

        def page_url(page)
          page.search('head link').first['href']
        end

        def page_body(page)
          page.search('section#postingbody').first&.text
        end

        def page_attrs(page)
          attr_group = page.search('div.mapAndAttrs p.attrgroup').first
          return {} unless attr_group

          attr_group.search('span').inject({}) {|out, el|
            key, val = el.text.split(': ')
            out[key] = val
            out
          }
        end

        def page_map(page)
          map_section = page_container(page).search('div.mapAndAttrs p.mapaddress a').first
          return '' unless map_section
          map_section['href']
        end

        def page_container(page)
          page.search('section#pagecontainer').first
        end

        def page_reply_path(page)
          if (link = page.search('a#replylink').first)
            link['href']
          else
            (link = page.search('a.showcontact').first) && link['href']
          end
        end
      end

      attr_reader :item, :title, :url, :body, :attrs, :map, :date, :reply_path

      def initialize(item, title:, url:, body:, attrs:, map:, date:, reply_path:)
        @item, @title, @url, @body = item, title, url, body
        @attrs, @map = attrs, map
      end

      def contact_info

      end


    end
  end
end

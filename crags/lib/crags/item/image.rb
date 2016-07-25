require 'uri'

module Crags
  class Item
     class Image
       BASE_URL = URI('https://images.craigslist.org')

       def self.for_data_ids(str)
         str.split(',').map { |id| new(id.split(':').last) }
       end

       attr_reader :id

       def initialize(id)
         @id = id
       end

       def thumb_url
         BASE_URL.clone.tap {|u| u.path = "/#{id}_50x50c.jpg"}.to_s
       end

       def medium_url
         BASE_URL.clone.tap {|u| u.path = "/#{id}_300x300.jpg"}.to_s
       end

       def large_url
         BASE_URL.clone.tap {|u| u.path = "/#{id}_600x450.jpg"}.to_s
       end
     end
  end
end

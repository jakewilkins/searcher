require 'digest'
class Result < Sequel::Model
  many_to_one :search
  one_to_many :notifications

  attr_writer :listing

  def self.from_crag(cres)
    new.tap {|r|
      r.url = cres.url
      r.hash = digest(cres.full.body)
      r.post_id = cres.post_id
      r.repost_of = cres.repost_of
      r.listing = cres
      r.cached_data = Sequel.hstore({
        'price' => cres.listing.price, 'title' => cres.listing.title,
        'image' => defaulted_image_url(cres)
      })
    }
  end

  def self.defaulted_image_url(listing)
    listing.images.first&.medium_url || "https://www.craigslist.org/images/peace.jpg"
  end

  def self.digest(str)
    d = Digest::MD5.new
    d << str
    d.hexdigest
  end

  def price
    cached_data&.fetch('price')
  end

  def title
    cached_data&.fetch('title')
  end

  def image
    cached_data&.fetch('image')
  end

end

require 'digest'
class Result < Sequel::Model
  many_to_one :search
  one_to_many :notifications

  attr_accessor :listing

  def self.from_crag(cres)
    new.tap {|r|
      r.url = cres.url
      r.hash = digest(cres.full.body)
      r.post_id = cres.post_id
      r.repost_of = cres.repost_of
      r.listing = cres
    }
  end

  def self.digest(str)
    d = Digest::MD5.new
    d << str
    d.hexdigest
  end

  def first_image_medium_url
    listing.images.first&.medium_url || "https://www.craigslist.org/images/peace.jpg"
  end
end

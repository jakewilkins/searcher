module Crags
  class Location
    attr_reader :domain

    def initialize(domain)
      @domain = domain
    end

    def url
      "https://#{domain}"
    end
  end
end

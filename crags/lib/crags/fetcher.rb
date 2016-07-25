module Crags
  module Fetcher
    def fetch_doc(url)
      Nokogiri::HTML.parse(fetch_xml(url))
    end

    def fetch_xml(url)
      resp = fetch_request(url)
      resp.body
    end

    def fetch_request(url)
      session = Patron::Session.new(timeout: 10_000, connect_timeout: 10_000)
      resp = session.get(url)
      resp
    end
  end
end

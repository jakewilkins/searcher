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

    def page_available?(url)
      session = Patron::Session.new(timeout: 10_000, connect_timeout: 10_000)
      head = session.head(url)
      if head.status < 400
        true
      else
        false
      end
    end
    module_function :page_available?
  end
end

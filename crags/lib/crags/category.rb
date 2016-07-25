require 'pathname'
require 'fileutils'

module Crags
  class Category
    module Cache
      PATH = Pathname.new(__FILE__).dirname.dirname.dirname.join('cache.yml')

      def self.available?
        File.exists?(PATH)
      end

      def self.set(data)
        File.write(PATH, Marshal.dump(data))
      end

      def self.load
        Marshal.load(File.read(PATH))
      end

      def self.destroy
        FileUtils.rm(PATH)
      end
    end

    class << self
      def doc
        fetch_doc(Config.category_url)
      end

      def links
        doc.search("div.col a").select do |link|
          (link["href"] =~ /forum/).nil?
        end
      end

      def all
        @all ||= begin
                   Cache.available? ? Cache.load : load_from_web
                 end
      end

      def find(arg)
        all.find_all {|c| c.name =~ /#{arg}/}
      end

      def [](arg)
        all.find {|c| c.shortcode == arg}
      end

      def cache
        Cache.set(all)
      end

      def clear_cache
        Cache.destroy
        @all = nil
      end

      private

      def load_from_web
        links.collect do |link|
          url = link["href"]
          name = link.children.first.text
          if url =~ %r|^/search/[a-z]{3}$|
            Category.new(name, url)
          else
            puts "disambiguating #{url} -- #{name}"
            disambiguate_category(url, name)
          end
        end.flatten
      end

      def disambiguate_category(url, name)
        disambiguation = Config.category_url + url
        fetch_doc(disambiguation).search('section.body div ul li a').map {|li|
          Category.new("#{name} - #{li.text}", li['href'])
        }
      end

    end

    extend Fetcher
    attr_reader :name, :url, :shortcode

    def initialize(name, abbr)
      @name = name
      @url = abbr[0] == '/' ? abbr : "/#{abbr}"
      @shortcode = url.split('/').last
    end

  end
end

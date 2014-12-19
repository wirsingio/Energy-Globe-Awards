require 'typhoeus'
require 'nokogiri'
require 'pry'
require 'minitest/autorun'
require 'minitest/spec'

URL = "http://www.energyglobe.at/awards/"

class AwardsScraper
  attr_reader :doc

  def initialize url
    @url = url
  end

  def scrape
    body = get_response_body
    @doc = Nokogiri::HTML(body)
    @doc.css("tr")[1..-1].map { |row|
      award = Award.new(row)
      award.parse
      award
    }
  end

  private

  def get_response_body
    req = RequestCache.new(@url)
    res = req.fetch
    res.body
  end
end

class Award
  attr_reader :jahr, :titel, :organisation, :kategorie,
              :award, :land, :einreicher, :inhalt, :bilder

  def initialize row
    @row = row
  end

  def parse
  end
end

class RequestCache
  CACHEFILE = "./.request_cache"
  # expire after one day
  FRESHTIME = ->(){ 60 * 60 * 24 }

  def initialize url
    @url = url
  end

  def fetch
    if raw = read_cache_file
      Marshal.load(raw)
    else
      make_and_cache_request
    end
  end

  private

  def read_cache_file
    if File.exists?(CACHEFILE) && file_is_fresh?
      File.read(CACHEFILE)
    end
  end

  def file_is_fresh?
    (Time.now - File.stat(CACHEFILE).mtime).to_f < FRESHTIME.call
  end

  def make_and_cache_request
    res = Typhoeus::Request.get(@url)
    serialized = Marshal.dump(res)
    File.open(CACHEFILE, "w") { |f| f.write(serialized) }
    res
  end
end

def main
  scraper = AwardsScraper.new(URL)
  puts scraper.scrape
end

describe "Award" do
  before {
    scraper = AwardsScraper.new(URL)
    @awards = scraper.scrape
  }

  it "should get the title" do
    @awards.first.title.must_equal "foo"
  end
end

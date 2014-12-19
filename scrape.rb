require 'typhoeus'
require 'nokogiri'
require 'pry'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'

URL = "http://www.energyglobe.at/awards/"

class AwardsScraper
  attr_reader :doc

  def initialize(url, cache=nil)
    @url = url
    @cache = cache
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
    if @cache
      Marshal.load(@cache).body
    else
      req = RequestCache.new(@url)
      res = req.fetch
      res.body
    end
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

class Award
  attr_reader :year, :title, :organization, :category,
              :award_won, :award_title,
              :country, :submitter, :description, :images,
              :details_link

  def initialize(row)
    @row = row
  end

  def parse
    @title = get_title
    @year = get_year
    @organization = get_org
    @details_link = get_link
    @category = get_category
    @award_won = won?
    @award_title = get_award_title
    @country = get_country
    @description = get_description
  end

  def won?
    @award_won ||= begin
      td = td_at(4)
      !!td.text.match(/winner/i)
    end
  end

  private

  def get_title
    td = @row.css('td')[1]
    td.at_css('a').text
  end

  def get_year
    td_at(0).text
  end

  def get_org
    td_at(2).text
  end

  def get_link
    td = td_at(1)
    td.at_css('a')['href']
  end

  def get_category
    text = td_at(3).text
    text.downcase if text
  end

  def get_award_title
    td = td_at(4)
    winner_span = td.at_css('span')
    if winner_span
      td_text = td.text
      td_text.sub(/#{winner_span.text}$/, '')
    else
      td.text
    end
  end

  def get_country
    td_at(-1).text
  end

  def get_description
    td = td_at(1)
    desc_element = td.at_css("span")
    desc_element.text
  end

  def td_at(n)
    @row.css('td')[n]
  end
end

def main
  scraper = AwardsScraper.new(URL)
  puts scraper.scrape
end

describe "Award" do
  before {
    scraper = AwardsScraper.new(nil, File.read('./spec/fixtures/request_cache_sample'))
    @awards = scraper.scrape
    @award = @awards.first
  }

  it "retreives basic award attributes from list page" do
    @award.title.must_equal(
      "Sägespäne aus Brennstoff zum Kochen und Heizen")
    @award.year.must_equal "2007"
    @award.organization.must_equal "Bikat Company Limited"
    @award.details_link.must_equal "/awards/details/awdid/9253/"
    @award.category.must_equal "fire"
    @award.award_won.must_equal true
    @award.award_title.must_equal "National 2008"
    @award.country.must_equal "Ghana"
    @award.description.must_equal %Q{Ziel des Projektes ist es, den Verbrauch von Feuerholz für Kochen und Heizung zu verringern indem Sägespäne als Brennstoff verwendet, um den Wald in Ghana zu schützen. Der Großteil der ländlichen Bevölkerung in Ghana ist durch die hohe Armut auf das Holz als Energieträger angewiesen. Der hohe Bedarf führt jedoch zur Entwaldung und Verwüstung des Landes. Die Regierung hatte schon Programme gestartet, die Energieversorgung auf Gas umzustellen, dies scheiterte jedoch auf Grund der hohen Armut in Ghana.}
  end
end

require 'bundler/setup'
Bundler.require
require 'digest'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'minitest/focus'

BASEURL   = "http://www.energyglobe.at"
AWARDSURL = "%s/awards/" % BASEURL

class AwardsScraper
  attr_reader :doc

  def initialize(base_url, awards_url, cache=nil)
    @awards_url = awards_url
    @base_url   = base_url
    @cache      = cache
  end

  def scrape
    body = get_response_body
    @doc = Nokogiri::HTML(body)
    @doc.css("tr")[1..-1].map { |row|
      award = Award.new(row, @base_url)
      award.parse
      award
    }
  end

  private

  def get_response_body
    if @cache
      Marshal.load(@cache).body
    else
      req = CachedRequest.new(@awards_url)
      res = req.fetch
      res.body
    end
  end
end

class CachedRequest
  CACHEDIR = "./tmp/cache"
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

  def cache_filepath
    "%s/%s.cache" % [CACHEDIR, Digest::MD5.hexdigest(@url)]
  end

  private

  def read_cache_file
    if File.exists?(cache_filepath) && file_is_fresh?
      File.read(cache_filepath)
    end
  end

  def file_is_fresh?
    (Time.now - File.stat(cache_filepath).mtime).to_f < FRESHTIME.call
  end

  def make_and_cache_request
    res = Typhoeus::Request.get(@url)
    serialized = Marshal.dump(res)
    File.open(cache_filepath, "w") { |f| f.write(serialized) }
    res
  end
end

class Award
  attr_reader :year, :title, :organization, :category,
              :details, :details_link,
              :award_won, :award_title,
              :country, :description

  def initialize(row, base_url)
    @row = row
    @base_url = base_url
  end

  def get_details
    link = get_link
    url = "%s%s" % [@base_url, link]
    res = CachedRequest.new(url)
    body = res.fetch.body
    @details = Nokogiri::HTML(body)
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

  def images
    return @images if @images
    if details
      if slides = @details.at_css(".slides_container")
        images = slides.css('img')
        return images.map { |img| "%s%s" % [@base_url, img['src']] if img }.compact
      end
    end
    return []
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
  scraper = AwardsScraper.new(AWARDSURL, BASEURL)
  puts scraper.scrape
end

describe "Award" do
  before {
    scraper = AwardsScraper.new(BASEURL, nil, File.read('./spec/fixtures/request_cache_sample'))
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

  describe "details" do
    let(:details) { @award.get_details }

    it "gets information from the details page" do
      details.to_s.must_match "Bikat Company Limited"
    end

    focus
    it "retreives images" do
      award_with_images = @awards.last
      award_with_images.get_details
      images = award_with_images.images
      images.size.must_equal 5
    end

    it "returns empty array when no images" do
      @award.images.must_equal []
    end
  end
end

require 'nokogiri'
require 'energy_globe_awards/award'
require 'energy_globe_awards/cached_request'

class AwardsScraper
  attr_reader :awards

  def initialize(base_url, awards_url, cache=nil)
    @awards_url = awards_url
    @base_url   = base_url
    @cache      = cache
  end

  def scrape_awards
    body = response_body
    doc = Nokogiri::HTML(body)
    @awards = doc.css("tr")[1..-1].map { |row|
      Award.new(row, @base_url)
    }
  end

  def request_award_details
    @awards.each do |award|
      award.request_details
    end
  end

  private

  def response_body
    if @cache
      Marshal.load(@cache).body
    else
      req = CachedRequest.new(@awards_url)
      res = req.fetch
      res.body
    end
  end
end

require 'nokogiri'
require 'energy_globe_awards/award'
require 'energy_globe_awards/cached_request'

class AwardsScraper
  attr_reader :doc, :awards

  def initialize(base_url, awards_url, cache=nil)
    @awards_url = awards_url
    @base_url   = base_url
    @cache      = cache
  end

  def scrape_awards
    body = get_response_body
    @doc = Nokogiri::HTML(body)
    @awards = @doc.css("tr")[1..-1].map { |row|
      award = Award.new(row, @base_url)
      award.parse
      award
    }
  end

  def request_award_details
    @awards.each do |award|
      award.get_details
    end
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

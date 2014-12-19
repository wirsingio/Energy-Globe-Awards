require 'bundler/setup'
Bundler.require
require 'digest'
require 'json'

BASEURL   = "http://www.energyglobe.at"
AWARDSURL = "%s/awards/" % BASEURL
DATAPATH  = "./data/awards.json"

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
    req = CachedRequest.new(url)
    puts "Requesting award at #{url}"
    res = req.fetch
    if res.code == 200
      puts "Request successful..."
      body = res.body
      @details = Nokogiri::HTML(body)
    else
      puts "Request failed..."
    end
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

  def to_json
    {
      title: title,
      year: year,
      organization: organization,
      details_link: details_link,
      category: category,
      award_won: won?,
      award_title: award_title,
      country: country,
      description: description,
      images: images
    }
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


class JSONWriter
  def initialize(awards, data_path)
    @awards = awards
    @data_path = data_path
  end

  def write!
    data = serialize_list
    raw = JSON.dump(data)
    File.open(@data_path, 'w') { |f| f.write(raw) }
  end

  def serialize_list
    @awards.map { |award|
      award.to_json
    }
  end
end

def main
  scraper = AwardsScraper.new(BASEURL, AWARDSURL)
  puts "Scraping..."
  scraper.scrape_awards
  puts "Scraping Details..."
  scraper.request_award_details
  writer = JSONWriter.new(scrape.awards, DATAPATH)
  puts "Writing json file to #{DATAPATH}..."
  writer.write!
  puts "Done..."
end

main

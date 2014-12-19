require 'energy_globe_awards/cached_request'
require 'nokogiri'

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

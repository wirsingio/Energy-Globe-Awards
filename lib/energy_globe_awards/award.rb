require 'energy_globe_awards/cached_request'
require 'nokogiri'

class Award
  attr_reader :details

  class NullElement
    def [](_)  '' end
    def text() '' end
    def method_missing(*_) NullElement.new end
  end

  def initialize(row, base_url)
    @row = row
    @base_url = base_url
  end

  def request_details
    url = '%s%s' % [@base_url, details_link]
    req = CachedRequest.new(url)
    puts "Requesting award at #{url}"
    res = req.fetch
    if res.code == 200
      puts 'Request successful...'
      body = res.body
      @details = Nokogiri::HTML(body)
    else
      puts 'Request failed...'
    end
  end

  def images
    if details && (slides = @details.at_css('.slides_container'))
      cache(:images) {
        slides.css('img').to_a
              .compact
              .map { |img| '%s%s' % [@base_url, img['src']]}
      }
    else
      []
    end
  end

  def won?
    @award_won ||= begin
      td = td_at(4)
      !!td.text.match(/winner/i)
    end
  end

  def title
    cache(:title) {
      td = @row.css('td')[1]
      td.at_css('a').text
    }
  end

  def year
    cache(:year) {
      td_at(0).text
    }
  end

  def organization
    cache(:organization) {
      td_at(2).text
    }
  end

  def details_link
    cache(:details_link) {
      td = td_at(1)
      td.at_css('a')['href']
    }
  end

  def category
    cache(:category) {
      text = td_at(3).text
      text.downcase if text
    }
  end

  def award_title
    cache(:award_title) {
      td = td_at(4)
      winner_span = td.at_css('span')
      if winner_span
        td.text.sub(/#{winner_span.text}$/, '')
      else
        td.text
      end
    }
  end

  def country
    cache(:country) {
      td_at(-1).text
    }
  end

  def description
    cache(:description) {
      td = td_at(1)
      desc_element = td.at_css('span')
      desc_element.text
    }
  end

  def to_json
    {
      title:        title,
      year:         year,
      organization: organization,
      details_link: details_link,
      category:     category,
      award_won:    won?,
      award_title:  award_title,
      country:      country,
      description:  description,
      images:       images
    }
  end

  private

  def td_at(n)
    @row.css('td')[n] || NullElement.new
  end

  def cache key
    @cache ||= {}
    @cache.fetch(key) {
      value = yield
      @cache[key] = value
      value
    }
  end
end

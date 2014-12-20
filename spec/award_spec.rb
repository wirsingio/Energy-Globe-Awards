$:.unshift File.expand_path('../../lib', __FILE__)
require 'energy_globe_awards'

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'minitest/focus'

BASEURL   = "http://www.energyglobe.at"
AWARDSURL = "%s/awards/" % BASEURL
DATAPATH  = File.expand_path "../../data/awards.json", __FILE__

describe "Award" do
  before do
    cache_file = File.expand_path('../fixtures/request_cache_sample', __FILE__)
    scraper = AwardsScraper.new(BASEURL, nil, File.read(cache_file))
    scraper.scrape_awards
    @award = scraper.awards.first
  end

  it "retrieves basic award attributes from list page" do
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

require File.expand_path('../spec_helper', __FILE__)
require 'energy_globe_awards/reprocess'

describe 'Reprocess' do
  before do
    @source = File.expand_path(
      '../fixtures/awards.json', __FILE__)
    @dest = File.expand_path(
      '../fixtures/awards-reprocessed.json', __FILE__)
    @processor = Reprocess.new(@source, @dest)
    @processor.reprocess
    @raw_dest = File.read(@dest)
    @dest_list = JSON.load(@raw_dest)
  end


  it 'reverses the list' do
    raw_source = File.read(@source)
    source_list = JSON.load(raw_source)
    # because hyphens
    @dest_list.first['title'][0..3].must_equal(
      source_list.reverse.first['title'][0..3])
  end

  it 'breaks the json onto lines' do
    @raw_dest.split("\n").size.must_equal 6
  end

  it "removes descriptions" do
    with_descriptions = @dest_list.reject { |item|
      item['description'].nil? }
    with_descriptions.size.must_equal 0
  end

  it 'adds hyphens to titles' do
    title = @dest_list.last['title']
    title.must_match(/&shy;/)
  end

  it 'adds hyphens to orgs' do
    organization = @dest_list.last['organization']
    organization.must_match(/&shy;/)
  end

  it 'removes the award descriptions' do
    descriptions = @dest_list.map { |award|
      award['description']
    }.compact
    descriptions.size.must_equal 0
  end

  it "consolidates categories" do
    categories = @dest_list.map { |item| item['category'] }
    categories.each do |category|
      Reprocess::VALID_CATEGORIES.must_include(category)
    end
    categories.must_include("other")
  end

  it 'translates countries' do
    countries = @dest_list.map { |award| award['country'] }
    countries.must_equal %w{Deutschland Slowakei Brasilien Ghana}
  end
end

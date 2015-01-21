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
  end

  it 'reverses the list' do
    raw_source = File.read(@source)
    raw_dest = File.read(@dest)
    source_list = JSON.load(raw_source)
    dest_list = JSON.load(raw_dest)
    # because hyphens
    dest_list.first['title'][0..3].must_equal(
      source_list.reverse.first['title'][0..3])
  end

  it 'breaks the json onto lines' do
    raw = File.read(@dest)
    raw.split("\n").size.must_equal 6
  end

  it 'adds hyphens' do
    # title is "Sägespäne aus Brennstoff zum Kochen und Heizen"
    raw_dest = File.read(@dest)
    dest_list = JSON.load(raw_dest)
    title = dest_list.last['title']
    title.must_match(/&shy;/)
  end

  it "consolidates categories" do
    raw_dest = File.read(@dest)
    dest_list = JSON.load(raw_dest)
    categories = dest_list.map { |item| item['category'] }
    categories.each do |category|
      Reprocess::VALID_CATEGORIES.must_include(category)
    end
    categories.must_include("other")
  end
end

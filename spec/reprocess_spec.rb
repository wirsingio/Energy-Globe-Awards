require File.expand_path('../spec_helper', __FILE__)
require 'energy_globe_awards/reprocess'

describe "Reprocess" do
  before do
    @source = File.expand_path(
      '../fixtures/awards.json', __FILE__)
    @dest = File.expand_path(
      '../fixtures/awards-reprocessed.json', __FILE__)
    @processor = Reprocess.new(@source, @dest)
  end

  it "reverses the list" do
    @processor.reprocess
    raw_source = File.read(@source)
    raw_dest = File.read(@dest)
    source_list = JSON.load(raw_source)
    dest_list = JSON.load(raw_dest)
    dest_list.must_equal source_list.reverse
  end

  it "breaks the json onto lines" do
    @processor.reprocess
    raw = File.read(@dest)
    raw.split("\n").size.must_equal 6
  end

  it "adds hyphens" do

  end

end

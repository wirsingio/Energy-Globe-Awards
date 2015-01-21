require File.expand_path('../spec_helper', __FILE__)

describe "Reprocess" do
  it "can be instantiated" do
    Reprocess.new(
      File.expand_path('../fixtures/awards.json', __FILE__),
      File.expand_path('../fixtures/awards-reprocessed.json', __FILE__))
  end

  it "breaks the json onto lines" do
  end

  it "adds hyphens" do
  end

  it "reverses the list" do
  end
end

require 'text/hyphen'

module HtmlHelpers

  def hyphenate(text)
    # right and left mean no fewer than this number of letters
    # will show up to the left or right of the hyphen.
    hyphenator = Text::Hyphen.new language: 'de', left:  2, right: 2
    text.split(" ").map {|word| hyphenator.visualize(word, "&shy;")}.join(" ")
  end
  
end

require 'json'
require 'text/hyphen'


class Reprocess
  VALID_CATEGORIES = %w(earth air water fire youth other)

  def initialize source, destination
    @source      = source
    @destination = destination
    @json        = []
  end

  def reprocess
    load_file
    reverse
    remove_descriptions
    hyphenate
    filter_categories
    print_to_file
  end

  private

  def load_file
    raw   = File.read(@source)
    @json = JSON.load(raw)
  end

  def reverse
    @json = @json.reverse
  end

  def remove_descriptions
    @json.each do |item|
      item.delete('description')
    end
  end

  def hyphenate
    # right and left mean no fewer than this number of letters
    # will show up to the left or right of the hyphen.
    hyphenator = Text::Hyphen.new(
      language: 'de',
      left:  2,
      right: 2
    )
    @json = @json.each do |award|
      award['title'] = hyphenate_sentence(award['title'], hyphenator)
      award['organization'] = hyphenate_sentence(award['organization'], hyphenator)
    end
  end

  def filter_categories
    @json.each do |item|
      unless VALID_CATEGORIES.include?(item['category'])
        item['category'] = 'other'
      end
    end
  end

  def print_to_file
    File.open(@destination, 'w') do |f|
      f << "[\n#{JSON.dump(@json.shift)}"
      @json.each do |line|
        f << ",\n#{JSON.dump(line)}"
      end
      f << "\n]\n"
    end
  end

  def hyphenate_sentence sentence, hyphenator
    sentence
      .split(" ")
      .map { |word|
        hyphenator.visualize(word, "&shy;") }
      .join(" ")
  end
end

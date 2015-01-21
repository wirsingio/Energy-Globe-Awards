require 'json'
require 'text/hyphen'


class Reprocess
  VALID_CATEGORIES = %w(earth air water fire youth other)

  def initialize source, destination
    @source      = source
    @destination = destination
    @json        = nil
  end

  def reprocess
    load_file
    reverse
    hyphenate
    filter_categories
    print_to_file
  end

  def load_file
    raw   = File.read(@source)
    @json = JSON.load(raw)
  end

  def reverse
    @json = @json.reverse
  end

  def hyphenate
    hh = Text::Hyphen.new(:language => 'de', :left => 2, :right => 2)
    @json = @json.map { |award|
      award['title'] = hyphenate_sentence(award['title'], hh)
      award['description'] = hyphenate_sentence(award['description'], hh)
      award
    }
  end

  def filter_categories
    @json.map! { |item|
      unless VALID_CATEGORIES.include?(item['category'])
        item['category'] = 'other'
      end
      item
    }
  end

  def print_to_file
    File.open(@destination, 'w') { |f|
      f << "["
      f << "\n#{JSON.dump(@json.shift)}"
      @json.each do |line|
        f << ",\n"
        f << JSON.dump(line)
      end
      f << "\n]"
    }
  end

  private

  def hyphenate_sentence sentence, hyphenator
    sentence
      .split(" ")
      .map { |word|
        hyphenator.visualize(word, "&shy;") }
      .join(" ")
  end


end
